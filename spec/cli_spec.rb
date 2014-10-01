require 'spec_helper'

describe Templater::CLI do
  describe '#run' do
    context 'prints out version' do
      before(:each) do
        @cli = create_cli('-v')
      end
      
      it 'print outs version' do
        @cli.should_receive(:puts).with("Version: #{Templater::VERSION}").once
      
        @cli.run
      end
    
      it 'exits on version' do
        @cli.should_receive(:exit)
      
        @cli.run
      end
    end
    
    context 'prints out help' do
      before(:each) do
        @cli = create_cli('-h')
      end
  
      it 'prints out invalid option' do
        @cli.should_receive(:puts).at_least(1)
  
        @cli.run
      end
  
      it 'exits' do
        @cli.should_receive(:exit)
  
        @cli.run
      end
    end
    
    context 'invalid option' do
      before(:each) do
        @cli = create_cli('-x')
      end
  
      it 'prints out invalid option and help' do
        @cli.should_receive(:puts).at_least(2)
  
        @cli.run
      end
  
      it 'exits' do
        @cli.should_receive(:exit)
  
        @cli.run
      end
    end
    
    context 'missing template and not a valid option' do
      before(:each) do
        @cli = create_cli()
      end
  
      it 'prints out invalid option and help' do
        @cli.should_receive(:puts).at_least(2)
  
        @cli.run
      end
  
      it 'exits' do
        @cli.should_receive(:exit)
  
        @cli.run
      end
    end
    
    context 'happy path' do
      before(:each) do
        @cli = create_cli('git@github.com/maschall/test-template.git')
      end
  
      it 'prints out template' do
        @cli.should_receive(:puts).with("Processing Template git@github.com/maschall/test-template.git:")
  
        @cli.run
      end
    end
  end
  
  def create_cli(*args)
    cli = Templater::CLI.new(args)
    cli.stub(:puts)
    cli.stub(:exit)
    cli
  end
end