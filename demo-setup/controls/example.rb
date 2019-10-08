# copyright: 2018, The Authors

title "Verify Ansible container setup"

# you add controls here
control "Tools" do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title "Verify that the necessary tools are available"             # A human-readable title
  desc "An optional description..."
  # Ansible 2.8 or greater is available
  describe package('ansible') do
    it { should be_installed }
    its('version') { should cmp >= '2.8' }
  end
  #Ubuntu is a debian derivative
  describe os.family do
    it {should eq 'debian'}
  end
  describe os.release do
    it {should cmp >= '18.04'}
  end
end

control "Connectivity" do
    impact 1.0
    title "Verify that all requisite connectivity is available"

    describe host(input('bigip_host'), port: input('bigip_mgmt_port'), protocol: 'tcp') do
        it { should be_reachable }
    end
end 
