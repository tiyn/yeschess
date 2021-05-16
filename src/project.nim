import os

proc getProjRootDir*(): string =
  ## Returns the root directory for the ychess project.
  var maxDepth = 4
  var path = os.getCurrentDir()
  var projectDir: string
  while maxDepth > 0:
    if dirExists(joinPath(path, "src")):
      projectDir = path
      break
    else:
      path = parentDir(path)
    maxDepth -= 1
  return projectDir
