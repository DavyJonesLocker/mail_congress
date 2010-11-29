require 'spec_helper'

describe PrintJob do
  describe '.enqueue' do
    before do
      ResqueSpec.reset!
      @letter = Letter.new
      @letter.stubs(:id).returns(1)
      PrintJob.enqueue(@letter)
    end

    it 'will push a new print job to Resque' do
      PrintJob.should have_queued(@letter.id)
    end
  end

  describe '.perform' do
    before do
      ResqueSpec.reset!
      @mail = mock('Mail')
      @mail.stubs(:deliver)
      SenderMailer.stubs(:print_notification).returns(@mail)
    end

    context 'succesfull printing' do
      before do
        @cups_print_job = mock('PrintJob')
        @cups_print_job.stubs(:print).returns(true)
        @cups_print_job.stubs(:state).returns(:processing).
          then.returns(:completed)
        Cups::PrintJob::Transient.stubs(:new).returns(@cups_print_job)
        @letter = Factory.build(:letter)
        @letter.stubs(:to_pdf).returns('')
        @letter.stubs(:id).returns(1)
        Letter.stubs(:find).returns(@letter)
        PrintJob.perform(@letter.id)
      end

      it 'creates a print job' do
        Cups::PrintJob::Transient.should have_received(:new)
      end

      it 'prints the letter' do
        @cups_print_job.should have_received(:print)
      end

      it 'waits until the printing is complete' do
        # 2 loops then the conditional
        @cups_print_job.should have_received(:state).times(3)
      end

      it 'converts the letters to pdf' do
        @letter.should have_received(:to_pdf)
      end

      it 'marks the letter as printed' do
        @letter.should be_printed
      end

      xit 'clears the body of the letter' do
        @letter.body.should be_empty
      end

      it 'sends a print confirmation email' do
        SenderMailer.should have_received(:print_notification).with(@letter)
        @mail.should have_received(:deliver)
      end

      it 'schedules a delivery notification 5 business days later' do
        Letter.should have_scheduled(@letter.id, :delivery_notification)
      end
    end
    
    context 'unsuccesfull printing' do
      before do
        @cups_print_job = mock('PrintJob')
        @cups_print_job.stubs(:print).returns(true)
        @cups_print_job.stubs(:state).returns(:aborted)
        Cups::PrintJob::Transient.stubs(:new).returns(@cups_print_job)
        @letter = Factory.build(:letter)
        @letter.stubs(:to_pdf).returns('')
        @letter.stubs(:update_attributes)
        Letter.stubs(:find).returns(@letter)
        PrintJob.stubs(:enqueue)
        PrintJob.perform(@letter.id)
      end

      it 'waits until the printing is complete' do
        @cups_print_job.should have_received(:state).times(2)
      end

      it 'does not mark the letter as printed' do
        @letter.should_not have_received(:update_attributes)
      end

      it 'should re-enqueue the job' do
        PrintJob.should have_received(:enqueue).with(@letter)
      end

      it 'does not send a print confirmation email' do
        SenderMailer.should_not have_received(:print_notification)
      end

      it 'does not schedule a notification email' do
        Letter.should_not have_queue_size_of(1)
      end
    end
  end

end
