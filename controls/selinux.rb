docker = inspec.file('/.dockerenv').exist?

control 'selinux' do
  title 'Verify SELinux state'

  if os.family == 'redhat' && !docker
    desired_state = input('selinux')

    describe selinux do
      it { should be_installed }
      it { should_not be_disabled }

      case desired_state
      when 'enforcing'
        it { should be_enforcing }
        it { should_not be_permissive }
      when 'permissive'
        it { should be_permissive }
        it { should_not be_enforcing }
      end
    end

    describe file('/var/log/audit/audit.log') do
      its('content') { should_not match /^type=AVC/ }
    end
  end
end
