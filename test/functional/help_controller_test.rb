# frozen_string_literal: true

# Redmine - project management software
# Copyright (C) 2006-  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require_relative '../test_helper'

class HelpControllerTest < Redmine::ControllerTest
  fixtures :users, :email_addresses

  def test_get_help_wiki_syntax
    formatters = {
      :textile => "Wiki Syntax Quick Reference",
      :markdown => "Wiki Syntax Quick Reference (Markdown)",
      :common_mark => "Wiki Syntax Quick Reference (CommonMark Markdown (GitHub Flavored))"
    }

    formatters.each {|formatter, result|
      with_settings :text_formatting => formatter do
        get :show_wiki_syntax

        assert_response :success
        assert_select 'h1', :text => result
      end
    }
  end

  def test_get_help_wiki_syntax_detailed
    formatters = {
      :textile => "Wiki formatting",
      :markdown => "Wiki formatting (Markdown)",
      :common_mark => "Wiki formatting (CommonMark Markdown (GitHub Flavored))"
    }

    formatters.each {|formatter, result|
      with_settings :text_formatting => formatter do
        get :show_wiki_syntax, :params => {
          :type => 'detailed'
        }

        assert_response :success
        assert_select 'h1', :text => result
      end
    }
  end

  def test_get_help_wiki_syntax_should_return_lang_if_available
    user = User.find(2)
    user.language = 'de'
    user.save!
    @request.session[:user_id] = 2

    get :show_wiki_syntax
    assert_response :success

    assert_select 'h1', :text => "Wiki Syntax Schnellreferenz (CommonMark Markdown (GitHub Flavored))"
  end

  def test_get_help_wiki_syntax_should_fallback_to_english
    user = User.find(2)
    user.language = 'ro'
    user.save!
    @request.session[:user_id] = 2

    get :show_wiki_syntax
    assert_response :success

    assert_select 'h1', :text => "Wiki Syntax Quick Reference (CommonMark Markdown (GitHub Flavored))"
  end

  def test_get_help_code_highlighting
    get :show_code_highlighting
    assert_response :success

    assert_select 'h1', :text =>  "List of languages supported by Redmine code highlighter"
  end
end
