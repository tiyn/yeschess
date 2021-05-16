import os

import src/project

let projDir = getProjRootDir()
var tmpPath: string

for dir in ["src", "tests"]:
  tmpPath = joinPath(projDir, dir)
  var f = open(joinPath(tmpPath, "nim.cfg"), fmWrite)
  f.writeLine("--outdir:\"" & joinPath(projDir, "bin", dir) & "\"")
  f.writeLine("--path:\"" & joinPath(projDir, "src") & "\"")
  f.close()
