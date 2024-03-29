ports = input('ssl_port')
host = input('ssl_host')
docker = inspec.file('/.dockerenv').exist?

control 'ssl-baseline' do
  title 'Verify SSL security'

  only_if('not in docker container') do
    !docker
  end

  ports.each do |port|
    describe ssl(port: port, host: host).ciphers(/WITH_3DES/) do
      it { should_not be_enabled }
    end

    describe ssl(port: port, host: host).ciphers(/WITH_RC4/) do
      it { should_not be_enabled }
    end

    %w(ssl2 ssl3 tls1.0 tls1.1).each do |p|
      describe ssl(port: port, host: host).protocols(p) do
        it { should_not be_enabled }
      end
    end
  end
end
