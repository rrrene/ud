#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

module UD
  module Formatting
    class << self

    # Fit a text in a given width (number of chars). It returns
    # a list of lines of text.
    def fit(txt, width=79)
      return [] if width < 1

      # from http://stackoverflow.com/a/7567210/735926
      r = /(.{1,#{width}})(?:\s|$)/m
      txt.split("\n").map { |l| l.scan(r) }.flatten
    end

    # Add a tab at the beginning of a text. If it's a list, add a tab at
    # the beginning of each element.
    # [txt] The text to tab, may be a string or a list of strings
    # [width] The width (number of spaces) of a tab
    def tab(txt, width=4)
      width = 0 if width < 0

      tab = ' ' * width

      return tab + txt if txt.is_a?(String)

      txt.map { |l| tab + l }
    end

    # Format results for text output (e.g. in the terminal)
    # [results] this must be an array of results, as returned by +UD.query+.
    def text(results, color=true)
      require 'colored' if color

      results.map do |r|

        word  = r[:word]
        upvotes = r[:upvotes]
        downvotes = r[:downvotes]

        if (color)
          word      = word.bold
          upvotes   = upvotes.to_s.green
          downvotes = downvotes.to_s.red
        end

        votes = "#{upvotes}/#{downvotes}"
        definition = tab(fit(r[:definition], 75)).join("\n")
        example    = tab(fit(r[:example], 75)).join("\n")

        s = ''

        s << "* #{word} (#{votes}):\n"
        s << "\n"
        s << definition
        s << "\n\n Example:\n"
        s << example
        s << "\n\n"

      end.join("\n")
    end

    end
  end
end
