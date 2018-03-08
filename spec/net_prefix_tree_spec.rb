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

require 'spec_helper'
require 'rspec'
require 'pp'
require_relative '../lib/nicinfo/net_prefix_tree'

describe 'net prefix tree test' do

  xit 'should insert' do

    t = NicInfo::NetPrefixTree.new
    t.insert( "10.0.0.0/24", 1 )
    t.insert( "10.0.0.0/16", 2 )
    t.insert( "10.0.0.0/25", 3 )
    t.insert( "9.0.0.0/24", 4 )
    t.insert( "11.0.0.0/24", 5 )
    expect( t.find_by_ipaddr( "10.0.0.1" ) ).to eq( 3 )
    expect( t.find_by_ipaddr( "10.0.1.1" ) ).to eq( 2 )
    expect( t.find_by_ipaddr( "9.0.1.1" ) ).to be_nil
    expect( t.find_by_ipaddr( "9.0.0.1" ) ).to eq( 4 )
    expect( t.find_by_ipaddr( "11.0.0.1" ) ).to eq( 5 )
    expect( t.find_by_ipaddr( "11.0.1.1" ) ).to be_nil
    t.insert( "11.0.0.0/16", 6 )
    expect( t.find_by_ipaddr( "11.0.1.1" ) ).to eq( 6 )
    expect( t.find_by_ipaddr( "11.0.0.1" ) ).to eq( 5 )
    t.insert( "13.0.0.0/8", 7 )
    expect( t.find_by_ipaddr( "10.0.0.1" ) ).to eq( 3 )
    expect( t.find_by_ipaddr( "10.0.1.1" ) ).to eq( 2 )
    expect( t.find_by_ipaddr( "9.0.1.1" ) ).to be_nil
    expect( t.find_by_ipaddr( "9.0.0.1" ) ).to eq( 4 )
    expect( t.find_by_ipaddr( "11.0.1.1" ) ).to eq( 6 )
    expect( t.find_by_ipaddr( "11.0.0.1" ) ).to eq( 5 )
    expect( t.find_by_ipaddr( "13.0.0.1" ) ).to eq( 7 )
    expect( t.find_by_ipaddr( "12.0.0.0" ) ).to be_nil
    t.insert( "11.1.0.0/16", 8 )
    expect( t.find_by_ipaddr( "11.1.0.1" ) ).to eq( 8 )
    expect( t.find_by_ipaddr( "11.2.0.1" ) ).to be_nil
    expect( t.find_by_ipaddr( "10.0.0.1" ) ).to eq( 3 )
    expect( t.find_by_ipaddr( "10.0.1.1" ) ).to eq( 2 )
    expect( t.find_by_ipaddr( "9.0.1.1" ) ).to be_nil
    expect( t.find_by_ipaddr( "9.0.0.1" ) ).to eq( 4 )
    expect( t.find_by_ipaddr( "11.0.1.1" ) ).to eq( 6 )
    expect( t.find_by_ipaddr( "11.0.0.1" ) ).to eq( 5 )
    expect( t.find_by_ipaddr( "13.0.0.1" ) ).to eq( 7 )

  end

end