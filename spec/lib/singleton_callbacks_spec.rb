require 'spec_helper'

describe Object do

  class Manager
    class << self
      include SingletonCallbacks

      def validate; 'validating' end
      def save; 'saving' end
      def notify; 'notifying' end

      before :save, :validate1
      before :save, :validate2
      after :save, :notify1
      after :save, :notify2
    end
  end

  let(:callbacks) { Manager.singleton_class.instance_variable_get :@callbacks }
  let(:expectation) {{
    before: [
      { method_sym: :save, callback_sym: :validate1, options: nil },
      { method_sym: :save, callback_sym: :validate2, options: nil }
    ],
    after: [
      { method_sym: :save, callback_sym: :notify1, options: nil },
      { method_sym: :save, callback_sym: :notify2, options: nil }
    ]
  }}

  it { expect(callbacks).to eq expectation }

  describe '.complex_save' do

    subject { Manager.save }

    before do
      expect(Manager).to receive(:validate1).ordered
      expect(Manager).to receive(:validate2).ordered
      expect(Manager).to receive(:original_save).and_return('saving').ordered
      expect(Manager).to receive(:notify1).ordered
      expect(Manager).to receive(:notify2).ordered
    end

    it { is_expected.to eq 'saving' }

  end

end