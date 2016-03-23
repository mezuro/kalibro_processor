require 'kolekti'
require 'kolekti_analizo'
require 'kolekti/cc_phpmd'

Kolekti.register_collector(Kolekti::Analizo::Collector)
Kolekti.register_collector(Kolekti::CcPhpMd::Collector)
