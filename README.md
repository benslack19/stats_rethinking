The purpose of this repo is to store notebooks and code for the assignments related to Statistical Rethinking. The data files, which are not a part of this repo, are in a separate directory within the overall project directory.

The folder structure for this project and repo also serves as a template for other projects moving forward.
- `environment.yml` Creates the `conda` virtual environment. 
- `active_pkg.py` Import and in the Jupyter notebook to reveal what package versions are being in the notebook (`how_pkg_vers_in_nb()`). It serves as a supplement to the `%watermark` magic function.
- `useful_git_scripts.sh` Snippets to place in the `.git/hooks/` directory. It will facilitate the updating of the `environment.yml` file as packages are added during a workflow.
