require 'spec_helper'
require 'mcb_helper'

describe 'running the mcb script' do
  describe 'config flag' do
    let(:config_file) { Tempfile.new(['new_config_file', '.yml']) }
    let(:config)      { { 'new' => 'day' } }

    it 'can set the path to the config file' do
      result = with_stubbed_stdout do
        File.write config_file.path, config.to_yaml
        $mcb.run(%W[-c #{config_file.path} config show])
      end

      expect(MCB.config_file).to eq config_file.path
      expect(result).to eq config.to_yaml
    end
  end

  describe 'REPL' do
    context 'completion' do
      it 'provides completions for empty prompt' do
        stderr = ''
        output = with_stubbed_stdout(stdin: "\t\t", stderr: stderr) do
          FakeFS do
            FileUtils.mkdir_p(File.expand_path('/tmp'))
            FileUtils.mkdir_p(File.expand_path('~'))

            MCB.start_mcb_repl([])
          end
        end

        expect(output).to include('providers')
        expect(output).to include('console')
        expect(output).to include('courses')
        expect(output).to include('config')
        expect(output).to include('apiv1')
        expect(output).to include('apiv2')
        expect(output).to include('users')
        expect(output).to include('az')
      end

      it 'provides relevant completions for a main command' do
        stderr = ''
        output = with_stubbed_stdout(stdin: "co\t\t", stderr: stderr) do
          FakeFS do
            FileUtils.mkdir_p(File.expand_path('/tmp'))
            FileUtils.mkdir_p(File.expand_path('~'))

            MCB.start_mcb_repl([])
          end
        end

        expect(output).not_to include('providers')
        expect(output).to include('console')
        expect(output).to include('courses')
        expect(output).to include('config')
        expect(output).not_to include('apiv1')
        expect(output).not_to include('apiv2')
        expect(output).not_to include('users')
        expect(output).not_to include('az')
      end
    end

    context 'history' do
      let(:up_key) { "\e[A" }
      it 'loads commands from saved history file' do
        stderr = ''
        output = with_stubbed_stdout(stdin: up_key, stderr: stderr) do
          FakeFS do
            FileUtils.mkdir_p(File.expand_path('/tmp'))

            FileUtils.mkdir_p(File.expand_path('~'))
            File.open(File.expand_path('~/.mcb_history'), 'w') do |f|
              f.puts('previous command')
            end
            MCB.start_mcb_repl([])
          end
        end
        expect(output).to match('previous command')
      end

      it 'eliminates duplicates from history' do
        stderr = ''
        output = with_stubbed_stdout(stdin: "i want to show this command\nduplicate command\nduplicate command\n#{up_key}#{up_key}", stderr: stderr) do
          FakeFS do
            FileUtils.mkdir_p(File.expand_path('/tmp'))

            FileUtils.mkdir_p(File.expand_path('~'))
            MCB.start_mcb_repl([])
          end
        end
        expect(output.scan('i want to show this command').size).to eq(2)
      end

      it 'eliminates empty items from history' do
        stderr = ''
        output = with_stubbed_stdout(stdin: "i want to show this command\n\n#{up_key}", stderr: stderr) do
          FakeFS do
            FileUtils.mkdir_p(File.expand_path('/tmp'))

            FileUtils.mkdir_p(File.expand_path('~'))
            MCB.start_mcb_repl([])
          end
        end
        expect(output.scan('i want to show this command').size).to eq(2)
      end

      it 'starts normally when history file is not present' do
        stderr = ''
        expect {
          with_stubbed_stdout(stdin: up_key, stderr: stderr) do
            FakeFS do
              FileUtils.mkdir_p(File.expand_path('/tmp'))
              FileUtils.mkdir_p(File.expand_path('~'))
              MCB.start_mcb_repl([])
            end
          end
        }.not_to raise_error
      end

      it 'appends to the history file on exit' do
        file_contents = nil
        stderr = ''
        with_stubbed_stdout(stdin: "my first command\nmy second command\n", stderr: stderr) do
          FakeFS do
            FileUtils.mkdir_p(File.expand_path('/tmp'))
            FileUtils.mkdir_p(File.expand_path('~'))

            File.open(File.expand_path('~/.mcb_history'), 'w') do |f|
              f.puts('old command')
            end
            MCB.start_mcb_repl([])

            file_contents = File.open(File.expand_path('~/.mcb_history'), 'r').read
          end
        end

        expect(file_contents).to include("old command\nmy first command\nmy second command\n")
      end
    end
  end
end
