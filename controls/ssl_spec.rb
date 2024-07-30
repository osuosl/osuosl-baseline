ports = input('ssl_port')
host = input('ssl_host')
begin
  ip_address = host || inspec.interfaces.ipv4_address
rescue IPAddr::InvalidAddressError
  ip_address = '127.0.0.1'
end

control 'ssl-baseline' do
  title 'Verify SSL security'

  ports.each do |port|
    describe ssl(port: port, host: ip_address).ciphers(/WITH_3DES/) do
      it { should_not be_enabled }
    end

    describe ssl(port: port, host: ip_address).ciphers(/WITH_RC4/) do
      it { should_not be_enabled }
    end

    %w(ssl2 ssl3 tls1.0 tls1.1).each do |p|
      describe ssl(port: port, host: ip_address).protocols(p) do
        it { should_not be_enabled }
      end
    end
  end
end
