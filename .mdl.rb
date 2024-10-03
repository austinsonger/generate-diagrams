#!/usr/bin/env ruby
all
exclude_rule 'MD007'  # leave 2 space indentation for lists, 3 space is ugly af
exclude_rule 'MD013'  # long lines cannot be split if they are URLs
exclude_rule 'MD033'  # inline HTML is important for formatting
exclude_rule 'MD036'  # emphasis used instead of header for footer Ported from lines
