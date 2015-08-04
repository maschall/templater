# RUBY requirement
require 'optparse'
require 'uri'
require 'yaml'
require 'erb'
require 'ostruct'
require 'fileutils'
require 'pathname'

# 3rd Party
require 'git'

# self
require 'templater/cli'
require 'templater/template'
require 'templater/template_attribute'
require 'templater/template_creator'
require 'templater/template_config'
require 'templater/template_fetcher'
require 'templater/template_processor'
require 'templater/version'