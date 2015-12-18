require 'kolekti'
require 'kolekti/analizo'

Kolekti.register_collector(Kolekti::Analizo::Collector.new)
