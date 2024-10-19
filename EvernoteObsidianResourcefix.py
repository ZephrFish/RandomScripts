import os
import shutil
import fnmatch

def move_resources_to_single_folder(parent_folder, destination_folder):
    if not os.path.exists(destination_folder):
        os.makedirs(destination_folder)
    
    found_any_resources = False

    
    for root, dirs, files in os.walk(parent_folder):
        print(f"Checking directory: {root}")  # Debugging: Show which directory is being checked
        print(f"Subdirectories: {dirs}")      # Debugging: Show which subdirectories are found
        print(f"Files: {files}")              # Debugging: Show which files are in the directory

        # Check for directories that are named '_resource' or end with '.resources'
        for dir_name in dirs:
            if dir_name == "_resource" or fnmatch.fnmatch(dir_name, '*.resources'):
                found_any_resources = True
                resource_folder_path = os.path.join(root, dir_name)
                destination_resource_folder_path = os.path.join(destination_folder, dir_name)
                
                # Move the whole directory into the destination folder (_resources)
                if not os.path.exists(destination_resource_folder_path):
                    print(f"Moving {resource_folder_path} to {destination_resource_folder_path}")
                    shutil.move(resource_folder_path, destination_resource_folder_path)
                else:
                    print(f"Folder {dir_name} already exists in {destination_folder}, skipping move.")

    if not found_any_resources:
        print(f"No _resource or *.resources folders found in {parent_folder}")

if __name__ == "__main__":
    parent_directory = 'notes'  # Root directory that contains the subdirectories with resources
    destination_resources_folder = os.path.join(os.getcwd(), '_resources')  # Destination folder in the current working directory

    move_resources_to_single_folder(parent_directory, destination_resources_folder)
