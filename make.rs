#!/usr/bin/env rust-script
//! ```cargo
//! [dependencies]
//! anyhow = "1.0"
//! git2 = "0.20"
//! regex = "1.11"
//! ```

use std::{
    env::{args, set_current_dir},
    fs::File,
    io::{BufRead, BufReader, BufWriter, Write},
    path::{Path, PathBuf},
    sync::LazyLock,
};

use anyhow::{anyhow, Context, Result};
use git2::{Oid, Repository, Tree};
use regex::bytes::Regex;

const SRC_DIR: &str = "src";
const TO_INCLUDE: &str = "src/include_in_package";
const COPYRIGHT_NOTE_FILE: &str = "copyright";
const OUTFILE: &str = "series.h";
const WARNING_MSG: &str = r##"#message WARNING: No series version specified
#message WARNING: Assuming series 1.0.1 for backwards compatibility
#message WARNING: Use "#include series.h # <VERSION>" to silence this warning
"##;

fn main() -> Result<()> {
    set_cwd()?;
    let repo = Repository::open(".")?;

    let out = File::create(OUTFILE)
        .with_context(|| format!("Failed to create {OUTFILE:?}"))?;
    let mut out = BufWriter::new(out);
    write_copyright(&mut out, COPYRIGHT_NOTE_FILE).with_context(|| {
        format!("Failed to copy copyright note to {OUTFILE:?}")
    })?;

    out.write_all(WARNING_MSG.as_bytes())
        .with_context(|| format!("Failed to write to {OUTFILE:?}"))?;

    repo.tag_foreach(|id, mut name| {
        // TODO: format of the name does not seem to be documented
        if let Some(start) = name.iter().rposition(|&c| c == b'/') {
            name = &name[(start + 1)..];
        }
        let name = std::str::from_utf8(name).unwrap();
        let res = push_tag(&mut out, &repo, id, name).with_context(|| {
            format!("Failed to write code for git tag {name} to {OUTFILE:?}")
        });
        // TODO: what does the return value even mean?
        res.inspect_err(|err| eprintln!("{err}")).is_ok()
    })?;

    Ok(())
}

fn set_cwd() -> Result<()> {
    let Some(cmd) = args().next() else {
        return Ok(());
    };
    if let Some(dir) = Path::new(&cmd).parent() {
        set_current_dir(dir)?
    }
    Ok(())
}

fn push_tag(
    mut out: impl Write,
    repo: &Repository,
    id: Oid,
    tag: &str,
) -> Result<()> {
    if tag == "1.0.0" {
        // this version does not have the required repository structure, yet
        return Ok(());
    }
    let is_default_version = tag == "1.0.1";
    let short_id_str = format!("{id:.7}");
    let commit = repo.find_commit(id)?;
    let tree = commit.tree()?;
    if !is_default_version {
        writeln!(out, "#if 1 == 0")?;
    }
    writeln!(out, "*--#[ {tag} :")?;
    let included_files = read_git_file(repo, &tree, TO_INCLUDE)?;
    for file in included_files.lines() {
        let file = file?;
        let include: PathBuf = [SRC_DIR, &file].into_iter().collect();
        let include = read_git_file(repo, &tree, include)?;
        if is_default_version {
            write_prc_1_0_1(&mut out, &include)
        } else {
            write_prc(&mut out, &include, &short_id_str)
        }
        .with_context(|| {
            format!("Failed to write {include:?} to {OUTFILE:?}")
        })?;
    }
    writeln!(out, "*--#] {tag} :")?;
    if !is_default_version {
        writeln!(out, "#endif")?;
    }
    Ok(())
}

fn read_git_file<'a, 'b>(
    repo: &'a Repository,
    tree: &'b Tree,
    path: impl AsRef<Path>,
) -> Result<Vec<u8>> {
    let path = path.as_ref();
    let file = tree.get_path(path)?;
    let file = file.to_object(repo)?;
    let file = file
        .as_blob()
        .ok_or_else(|| anyhow!("{path:?} is not a blob"))?;
    Ok(file.content().to_owned())
}

fn write_copyright(
    mut out: impl Write,
    copyright_file: impl AsRef<Path>,
) -> Result<()> {
    let copyright_file = copyright_file.as_ref();
    let input = File::open(copyright_file)
        .with_context(|| format!("Failed to open {copyright_file:?}"))?;
    for (n, line) in BufReader::new(input).lines().enumerate() {
        let n = n + 1;
        let line = line.with_context(|| {
            format!("Failed to read line {n} from {copyright_file:?}")
        })?;
        writeln!(out, "* {line}")?
    }
    Ok(())
}

static LOCAL_VAR: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(r"\[:(.*?)\]").unwrap());
static DOLLAR_VAR: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(r"(^|[^\%])\$").unwrap());
static PRC: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(r"#(procedure|call) +([^@])").unwrap());

fn write_prc_1_0_1(mut out: impl Write, txt: &[u8]) -> Result<()> {
    let txt = LOCAL_VAR.replace_all(txt.as_ref(), b"[series::$1]");
    let txt = DOLLAR_VAR.replace_all(txt.as_ref(), b"$1$$series");
    let txt = PRC.replace_all(txt.as_ref(), b"#$1 `NAMESPACE'");
    out.write_all(txt.as_ref())?;
    Ok(())
}

fn write_prc(mut out: impl Write, txt: &[u8], prefix: &str) -> Result<()> {
    let txt = LOCAL_VAR
        .replace_all(txt.as_ref(), format!("[{prefix}::$1]").as_bytes());
    let txt = DOLLAR_VAR.replace_all(
        txt.as_ref(),
        // prefix with another 's' so that the name of the $ variable
        // is guaranteed to start with a letter
        format!("$1$$s{prefix}").as_bytes(),
    );
    let txt =
        PRC.replace_all(txt.as_ref(), format!("#$1 s{prefix}$2").as_bytes());
    let mut txt = txt.into_owned();
    txt.retain(|&c| c != b'@');
    out.write_all(txt.as_ref())?;
    Ok(())
}
