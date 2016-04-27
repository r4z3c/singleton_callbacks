require 'spec_helper'

describe Object do

  class Manager
    class << self
      def validate; 'validating' end
      def save; 'saving' end
      def notify; 'notifying' end
    end

    include SingletonCallbacks

    before :save, :validate
    after :save, :notify
  end

  let(:callbacks) { Manager.instance_variable_get :@callbacks }
  let(:expectation) {{
    before: [ { method_sym: :save, callback_sym: :validate, options: nil } ],
    after: [ { method_sym: :save, callback_sym: :notify, options: nil } ]
  }}

  it { expect(callbacks).to eq expectation }

  describe '.complex_save' do

    subject { Manager.save }

    before do
      expect(Manager).to receive(:validate).ordered
      expect(Manager).to receive(:notify).ordered
    end

    it { is_expected.to eq 'saving' }

  end

end