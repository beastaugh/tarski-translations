# This script was used to import translation files from the old Subversion
# repository on Google Code.
#
# http://tarski.googlecode.com/svn/translations/
#
# Subversion repository layout:
#
# /translations/
# /translations/releases/{1.4...2.4}
# /translations/trunk/

require 'pathname'
require 'find'
require 'fileutils'

SVN_PATH = "http://tarski.googlecode.com/svn/translations/"

THIS_DIR = Pathname.new(File.dirname(__FILE__)) + "../"

TMP_DIR  = THIS_DIR + "tmp"
BIN_DIR  = THIS_DIR + "bin"
SRC_DIR  = THIS_DIR + "src"

# Check out the translation files from the Subversion repository
`svn co #{SVN_PATH}releases tmp`
`svn cp #{SVN_PATH}/trunk tmp/2.5`

# Copy the files from the temporary directory to the correct location in the
# new repository. It is assumed that the new directory structure already
# exists, e.g. that there are bin/ and src/ directories with correctly numbered
# version directories.
Find.find(TMP_DIR) do |path|
  if FileTest.directory?(path)
    if File.basename(path)[0] == ?.
      Find.prune
    else
      next
    end
  else
    version = File.dirname(path).split("/").last
    ext     = File.extname(path)
    name    = File.basename(path)
    
    if ext == ".mo"
      FileUtils.cp(path, BIN_DIR + version + name)
    elsif ext == ".po"
      FileUtils.cp(path, SRC_DIR + version + name)
    elsif ext == ".pot"
      FileUtils.cp(path, SRC_DIR + "template" + "tarski_#{version}.pot")
    end
  end
end
