# csv.kak

**csv.kak** is a plugin for [Kakoune][1] editor that gives colors to the columns 
on csv. This helps to read and edit csv-files that have many columns, especially 
if the cells have clearly different widths.

![csvcolors](https://raw.githubusercontent.com/gspia/csv.kak/master/csvcolors.png)

![ohlc_csv](https://raw.githubusercontent.com/gspia/csv.kak/master/ohlc_csv.png)


## Installation

Installation can be done, e.g., with plug.kak plugin manager or manually. With 
plugin manager

```kak
plug "gspia/csv.kak" %{
	set-option global csv_sep ';'
}
```

(You don't need to set the option if the default ',' is ok for you.)
Then reload Kakoune config or restart Kakoune and run `:plug-install`.


## Usage

**csv.kak** recognizes csv-files based on filenames ending on "csv" and uses hooks
to set and unset the highlighters.

You may configure the two options provided in your Kakoune config. The options 
and their default values are

 * csv_sep ','
 * csv_colors "yellow red cyan green blue rgb:993286 magenta"
 
Further, there are two commands 

 * csv-enable 
 * csv-disable 
 
Enable command takes one parameter, that is, the separator. This can be used
in cases, when you have to open several csv-files where some of the of the
files use different separator than your default one. Just give, e.g.

```kak
:csv-enable ';'
```
in those cases.

[1]: https://github.com/mawww/kakoune
