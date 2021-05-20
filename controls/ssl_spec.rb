port = input('ssl_port')
host = input('ssl_host')

control 'ssl-baseline' do
  describe ssl(port: port, host: host).ciphers('TLS_RSA_WITH_3DES_EDE_CBC_SHA') do
    it { should_not be_enabled }
  end

  %w(ssl2 ssl3 tls1.0 tls1.1).each do |p|
    describe ssl(port: port, host: host).protocols(p) do
      it { should_not be_enabled }
    end
  end
end
