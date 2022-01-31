#! /usr/bin/env python3

import os
import json
import copy


folder_this = os.path.dirname(__file__)
folder_catalog = os.path.join(folder_this, "catalog")


record = set()

def traverse_primary(folder, top):
   extension = "pdf"
   for thing in os.scandir(folder):
      if not thing.is_dir():
         continue
      primary = set()
      name = thing.name
      subfolder = os.path.join(folder, name)
      traverse_secondary(subfolder, primary)

def traverse_secondary(folder, primary):
   extension = "pdf"
   for thing in os.scandir(folder):
      if not thing.is_file():
         continue
      if not name.endswith(extension):
         continue
      secondary = set()
      name = thing.name
      bare = string[:string.index(":")]
      author, title = give_credit(bare)
      size = thing.stat().st_size
      entry = tuple(author, title, size)
      secondary.insert(entry)

def give_credit(bare):
   unified = bare
   unified = unified.replace(' ', '-')
   unified = unified.replace('_', '-')
   many_segment = unified.split(',')
   author = many_segment[0]
   title = many_segment[1]
   return author, title

