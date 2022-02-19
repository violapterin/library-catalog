#! /usr/bin/env python3

import os
import sys

def main(folder_book):
   folder_this = os.path.dirname(__file__)
   record = list()
   traverse_primary(folder_book, record)
   path_markdown = os.path.join(folder_this, "catalog-markdown.md")
   output_file(path_markdown, publish_markdown(folder_this, record))
   #path_latex = os.path.join(folder_this, "catalog-markdown.md")
   #output_file(path_markdown, publish_latex())

def traverse_primary(folder, root):
   for thing in os.scandir(folder):
      if not thing.is_dir():
         continue
      record = list()
      name = thing.name
      subfolder = os.path.join(folder, name)
      traverse_secondary(subfolder, record)
      entry = {
         "name": name,
         "object": record,
      }
      root.append(entry)

def traverse_secondary(folder, primary):
   for thing in os.scandir(folder):
      if not thing.is_dir():
         continue
      record = list()
      name = thing.name
      subfolder = os.path.join(folder, name)
      traverse_tertiary(subfolder, record)
      entry = {
         "label": name,
         "object": record,
      }
      primary.append(entry)

def traverse_tertiary(folder, secondary):
   extension = "pdf"
   for thing in os.scandir(folder):
      if not thing.is_file():
         continue
      name = thing.name
      if not name.endswith(extension):
         continue
      bare = name[:name.index('.')]
      author, title = give_credit(bare)
      size = thing.stat().st_size
      #page = give_page()
      entry = {
         "author": author,
         "title": title,
         "size": size,
         #"page": page,
      }
      print("entry:", entry)
      secondary.append(entry)

def give_credit(bare):
   unified = bare
   unified = unified.replace(' ', '-')
   unified = unified.replace('_', '-')
   many_segment = unified.split(',')
   author = ''
   if many_segment:
      author = many_segment.pop(0)
      author = author.strip(' _-')
   title = ''
   if many_segment:
      title = many_segment.pop(0)
      title = title.strip(' _-')
   return author, title

def publish_markdown(folder, record):
   result = ''
   result += "author" + '\n'
   result += "title" + '\n'
   for primary in record:
      for secondary in primary:
         for entry in secondary:
            result += publish_entry_markdown(entry)
   return result

def publish_entry_markdown(entry):
   result = ''
   result += '|'
   result += ' ' + entry.get("author") + ' ' + '|'
   result += ' ' + entry.get("title") + ' ' + '|'
   result += '\n'
   return result

# XXX
def give_page():
   return

def output_file(path, sink):
   print("output:")
   handle = open(path, mode = 'w')
   handle.write(sink)
   handle.close()

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if (len(sys.argv) == 0):
   print("Please insert the name of directory.")
folder_book = sys.argv[1]
main(folder_book)