#! /usr/bin/env python3

import os
import sys

def main(folder_book):
   folder_this = os.path.dirname(__file__)
   record = list()
   traverse_primary(folder_book, record)
   for kind in ["markdown", "latex"]:
      extension = ({"markdown": "md", "latex": "tex"}).get(kind)
      path = os.path.join(folder_this, f"catalog-{kind}.{extension}")
      publish_record(kind, path, record)

def traverse_primary(root, record):
   for thing in os.scandir(root):
      if not thing.is_dir():
         continue
      label = thing.name
      folder = list()
      traverse_secondary(os.path.join(root, label), folder)
      primary = {
         "label": label,
         "folder": folder,
      }
      record.append(primary)

def traverse_secondary(folder, primary):
   for thing in os.scandir(folder):
      if not thing.is_dir():
         continue
      sublabel = thing.name
      subfolder = list()
      traverse_tertiary(os.path.join(folder, sublabel), subfolder)
      secondary = {
         "sublabel": sublabel,
         "subfolder": subfolder,
      }
      primary.append(secondary)

def traverse_tertiary(folder, subfolder):
   extension = "pdf"
   for thing in os.scandir(folder):
      if not thing.is_file():
         continue
      name = thing.name
      if not name.endswith(extension):
         continue
      bare = name[:name.index('.')]
      author, title = give_credit(bare)
      byte = thing.stat().st_size
      size = give_size(byte)
      #page = give_page()
      entry = {
         "author": author,
         "title": title,
         "size": size,
         #"page": page,
      }
      subfolder.append(entry)

def publish_record(kind, path, record):
   width = 3 # author, title, size
   header = ''
   start = ''
   cut = ''
   end = ''
   if (kind == "markdown"):
      separator = '|' + " ---- |" * width
      start = "| "
      cut = " | "
      end = " |"
      header += start
      header += "author" + cut
      header += "title" + cut
      header += "size" + end + '\n'
      header += separator + '\n'
   elif (kind == "latex"):
      declaration = '\\begin{tabular} {' + " c" * width + " }"
      start = "  "
      cut = " & "
      end = " \\\\"
      header += declaration + '\n'
      header += start
      header += "author" + cut
      header += "title" + cut
      header += "size" + end + '\n'

   result = ''
   many_escape = ["CATALOGS"]
   for primary in record:
      label = str(primary.get("label"))
      if label in many_escape:
         continue
      folder = primary.get("folder")
      result += '\n' + "# " + label + "\n\n"
      for secondary in folder:
         sublabel = str(secondary.get("sublabel"))
         subfolder = secondary.get("subfolder")
         result += '\n' + "## " + sublabel + "\n\n"
         result += header
         for entry in subfolder:
            row = ''
            row += start
            row += entry.get("author") + cut
            row += entry.get("title") + cut
            row += entry.get("size") + end
            result += row + '\n'
   output_file(path, result)

def give_credit(bare):
   unified = bare
   unified = unified.replace('-', ' ')
   unified = unified.replace('_', ' ')
   many_segment = unified.partition(',')
   author = ''
   if many_segment:
      author = many_segment[0]
      author = author.strip(' _-')
   title = ''
   if many_segment:
      title = many_segment[2]
      title = title.strip(' _-')
   return author, title

def give_size(byte):
   number = byte
   thousand = 1024
   number = number/thousand
   if number <= thousand:
      return f"{number:4.2f}" + 'K'
   number = number/thousand
   if number <= thousand:
      return f"{number:4.2f}" + 'M'
   number = number/thousand
   return f"{number:4.2f}" + 'G'

# XXX
def give_page():
   return

def output_file(path, sink):
   handle = open(path, mode = 'w')
   handle.write(sink)
   handle.close()

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if (len(sys.argv) == 0):
   print("Please insert the name of directory.")
folder_book = sys.argv[1]
main(folder_book)