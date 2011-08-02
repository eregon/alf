task :"gh-pages" do
  require 'fileutils'
  require 'wlang'
  require 'alf'

  indir  = File.expand_path('../gh-pages', __FILE__)
  outdir = File.expand_path('../../doc/gh-pages', __FILE__)

  # copy assets
  FileUtils.cp_r File.join(indir, "css"), outdir

  # launch wlang on main template
  puts WLang::file_instantiate File.join(indir, 'main.wtpl'), {
    :version => Alf::VERSION,
    :outdir  => outdir,
    :main    => Alf::Command::Main
  }
end
