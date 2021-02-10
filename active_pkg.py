#!/Users/blacar/opt/anaconda3/envs/stats_rethinking/bin/python

"""
Purpose: Function to list packages in the current notebook
Created 2/8/21
@author: benlacar
"""

# I think this function has to be run in the jupyter notebook    
# def imports():
#       """
#       This is a list of active packages, but without versions
#       """
#     import types
#     for name, val in globals().items():
#         if isinstance(val, types.ModuleType):
#             yield val.__name__

# This will be run within the notebook.
# imported_packages = list(imports())

def show_pkg_vers_in_nb(imported_packages):
    """
    Objective of this function is to show the packages and versions
    that are active in this notebook.
    
    Partly informed by these links:
    https://stackoverflow.com/questions/40428931/package-for-listing-version-of-packages-used-in-a-jupyter-notebook
    https://stackoverflow.com/questions/4256107/running-bash-commands-in-python/51950538
    """
    
    # Shows list of packages and versions from pip...
    # # but doesn't have conda hence the next command
    # pip_freeze_contents = !pip freeze

    # print('Test text at top of function')

    # This line acccounts for imported submodules (e.g. matplotlib.pyplot)
    imported_packages = [i.split('.')[0] for i in imported_packages]
    
    # Shows list of packages and versions from pip and conda
    bash_cmd = "conda list"

    #bash_cmd = 'bash -c "source activate stats_rethinking";

    import subprocess
    # process = subprocess.Popen(bash_cmd.split(), stdout=subprocess.PIPE)
    # process = subprocess.Popen(bash_cmd, shell=True, stdout=subprocess.PIPE)
    # # conda_pkgs, error = process.communicate

    process = subprocess.run(bash_cmd.split(), capture_output=True)
    conda_pkgs = str(process.stdout).split('\\n')    # turns bytes output to a list
    # print("conda packages: ", conda_pkgs)

    # This essentially takes an intersection of the two lists
    for pkg_vers in conda_pkgs:
        
        # Header row
        if pkg_vers.startswith('# Name'):
            print(pkg_vers)
        
        elif pkg_vers.split(' ')[0] in imported_packages:
            print(pkg_vers)

# Other research for historical purposes   ----------
# From here:
# https://stackoverflow.com/questions/38267791/how-to-i-list-imported-modules-with-their-version

# This block below doesn't work for me

# import sys
# for module_name in modules:
#     module = sys.modules[module_name]
#     print module_name, getattr(module, '__version__', 'unknown')