import pandas as pd
import glob
import os


"""
TASK: 
Create a Python Script that parses all downloaded files held within the input path
read all *.csv file pathes into a list
loop through list and concat all into one file
"""
input_path = 'PATH/TO/FOLDER'
output_path = "PATH/TO/FOLDER"
file_name = 'all_years.csv'
csvs = glob.glob(os.path.join(input_path, "*.csv"))

files = []
for file in csvs: 
	df = pd.read_csv(file, index_col =None, header=0)
	files.append(df)

df_concat = pd.concat(files, axis=0, ignore_index=True)

df_concat.to_csv(output_path+"/"+file_name)
