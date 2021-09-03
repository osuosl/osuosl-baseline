control 'selinux' do
  title 'Verify SELinux state'

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
end
