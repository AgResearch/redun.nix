import os
from redun import task, File

from Bio.Seq import Seq

redun_namespace = "agr.redun.example.seq"


@task()
def write_complement(path: str, seq: Seq) -> File:
    c = seq.complement()
    with open(path, "w") as out_f:
        out_f.write(f"{c}\n")


@task()
def main() -> File:
    os.makedirs("out", exist_ok=True)
    return write_complement("out/a.seq", Seq("AGTC"))
