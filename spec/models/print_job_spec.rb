require 'spec_helper'

describe PrintJob do
  describe '.enqueue' do
    before do
      @letter = Letter.new
      @letter.stubs(:id).returns(1)
      PrintJob.enqueue(@letter)
    end

    it 'will push a new print job to Resque' do
      PrintJob.should have_queued(@letter.id)
    end
  end

  describe '.perform' do
    context '1 recipient' do
      before do
        @cups_print_job = mock('PrintJob')
        @cups_print_job.stubs(:print).returns(true)
        @cups_print_job.stubs(:state).returns(:processing).
          then.returns(:completed)
        Cups::PrintJob::Transient.stubs(:new).returns(@cups_print_job)
        @letter = Factory.build(:letter)
        @letter.stubs(:to_pdf).returns('')
        Letter.stubs(:find).returns(@letter)
        PrintJob.perform(@letter.id)
      end

      it 'creates 1 print job' do
        Cups::PrintJob::Transient.should have_received(:new)
      end

      it 'prints the letter' do
        @cups_print_job.should have_received(:print)
      end

      it 'waits until the printing is complete' do
        @cups_print_job.should have_received(:state).times(2)
      end

      it 'converts the letters to pdf' do
        @letter.should have_received(:to_pdf)
      end
    end
  end

end
