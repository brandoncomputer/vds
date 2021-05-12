del setup
mkdir setup
copy vds.psm1 setup
mkdir setup\compile
copy .\compile\*.ps1 .\setup\compile
mkdir setup\examples
copy .\examples .\setup\examples
mkdir setup\examples\en-US
copy .\examples\en-US .\setup\examples\en-US
mkdir setup\elements
copy .\elements .\setup\elements
mkdir setup\res
xcopy .\res .\setup\res\ /E/H
mkdir setup\plugins
copy .\plugins .\setup\plugins
mkdir setup\wizards
copy .\wizards .\setup\wizards
copy .\license.md .\setup\license.md

setup.bat