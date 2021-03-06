# Copyright (C) 2018 American Registry for Internet Numbers
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
# IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


require 'tmpdir'
require 'fileutils'
require 'pp'
require 'spec_helper'
require 'rspec'
require_relative '../lib/nicinfo/appctx'
require_relative '../lib/nicinfo/ip'

describe 'ip spec' do

  @work_dir = nil

  before( :all ) do

    @work_dir = Dir.mktmpdir

  end

  after( :all ) do

    FileUtils.rm_rf( @work_dir )

  end

  it 'should handle ex1' do

    dir = File.join( @work_dir, "test_ip_ex1" )

    logger = NicInfo::Logger.new
    logger.message_out = StringIO.new
    logger.message_level = NicInfo::MessageLevel::NO_MESSAGES
    appctx = NicInfo::AppContext.new( dir )
    appctx.logger=logger

    json_data = JSON.load( File.read( "spec/other_resources/ip_ex1.json" ) )
    ip = NicInfo::Ip.new( appctx )
    ip.process( json_data )

    meta_data = ip.objectclass[ NicInfo::CommonSummary::SUMMARY_DATA_NAME ]

    expect( meta_data[ NicInfo::CommonSummary::SERVICE_OPERATOR ] ).to eq("apnic.net" )

    expect( meta_data[ NicInfo::CommonSummary::LISTED_NAME ] ).to eq("Jinxia Sun ( JS686-AP )" )
    expect( meta_data[ NicInfo::CommonSummary::LISTED_COUNTRY ] ).to eq("CN" )
    expect( meta_data[ NicInfo::CommonSummary::ABUSE_EMAIL ] ).to eq("abuse@chinamobile.com" )
    expect( meta_data[ NicInfo::CommonSummary::REGISTRATION_DATE ] ).to be_nil
    expect( meta_data[ NicInfo::CommonSummary::EXPIRATION_DATE ] ).to be_nil
    expect( meta_data[ NicInfo::CommonSummary::LAST_CHANGED_DATE ] ).to eq("Wed, 30 Aug 2017 07:22:04 -0000" )

    expect( meta_data[ NicInfo::CommonSummary::CIDRS ].length ).to eq( 1 )
    expect( meta_data[ NicInfo::CommonSummary::CIDRS ][0] ).to eq( "111.0.0.0/10" )
  end

end
