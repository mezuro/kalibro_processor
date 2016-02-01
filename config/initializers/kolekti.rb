require 'kolekti'
require 'kolekti_analizo'

Kolekti.register_collector(Kolekti::Analizo::Collector.new)
