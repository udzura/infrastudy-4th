MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'
  conf.gem core: 'mruby-io'
  conf.gem mgem: 'mruby-process'
  conf.gem mgem: 'mruby-dir'
  conf.gem github: 'haconiwa/mruby-linux-namespace'
  conf.gem github: 'haconiwa/mruby-exec'
  conf.enable_debug
end
