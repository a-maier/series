#!/usr/bin/env rust-script
//! ```cargo
//! [dependencies]
//! anyhow = "1.0"
//! regex = "1.11"
//! ```

use std::{
    fs::{File, read_to_string},
    io::{BufRead, BufReader, BufWriter, Write},
    path::{Path, PathBuf},
    sync::LazyLock,
};

use anyhow::{Context, Result};
use regex::Regex;

const SRC_DIR: &str = "src";
const TO_INCLUDE: &str = "src/include_in_package";
const COPYRIGHT_NOTE_FILE: &str = "copyright";
const OUTFILE: &str = "series.h";

const HEADER: &str = r#"
*Header file for the series package - contains all procedures

#ifndef `SERIESPACKAGE'
#define SERIESPACKAGE

*global definitions
#ifndef `NAMESPACE'
#define NAMESPACE ""
#endif
"#;
const FOOTER: &str = "#endif\n";

fn main() -> Result<()> {
    let out = File::create(OUTFILE)
        .with_context(|| format!("Failed to create {OUTFILE:?}"))?;
    let mut out = BufWriter::new(out);
    write_copyright(&mut out, COPYRIGHT_NOTE_FILE)
        .context("Failed to copy copyright note")?;

    out.write_all(HEADER.as_bytes())
        .with_context(|| format!("Failed to write header to {OUTFILE:?}"))?;

    let included_files = File::open(TO_INCLUDE)
        .with_context(|| format!("Failed to open {TO_INCLUDE:?}"))?;
    let included_files: Result<Vec<_>, _> =
        BufReader::new(included_files).lines().collect();
    for file in included_files? {
        let include: PathBuf = [SRC_DIR, &file].into_iter().collect();
        write_prc(&mut out, &include)
            .with_context(|| format!("Failed to write {include:?} to {OUTFILE:?}"))?;
    }

    out.write_all(FOOTER.as_bytes())
        .with_context(|| format!("Failed to write footer to {OUTFILE:?}"))?;

    Ok(())
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

fn write_prc(
    mut out: impl Write,
    prc_file: impl AsRef<Path>,
) -> Result<()> {
    static LOCAL_VAR: LazyLock<Regex> = LazyLock::new(|| Regex::new(r"\[:(.*?)\]").unwrap());
    static DOLLAR_VAR: LazyLock<Regex> = LazyLock::new(|| Regex::new(r"(^|[^\%])\$").unwrap());
    static PRC: LazyLock<Regex> = LazyLock::new(|| Regex::new(r"#(procedure|call) ").unwrap());

    let txt = read_to_string(prc_file)?;
    let txt = LOCAL_VAR.replace_all(txt.as_ref(), "[series::$1]");
    let txt = DOLLAR_VAR.replace_all(txt.as_ref(), r"$1$$series");
    let txt = PRC.replace_all(txt.as_ref(), "#$1 `NAMESPACE'");
    out.write_all(txt.as_bytes())?;
    Ok(())
}
