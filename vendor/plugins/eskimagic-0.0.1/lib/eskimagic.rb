require "active_record"

require File.dirname(__FILE__) + "/eskimagic/acts_as_eskimagic/base"
require File.dirname(__FILE__) + "/eskimagic/acts_as_eskimagic/basic"
require File.dirname(__FILE__) + "/eskimagic/acts_as_eskimagic/recycle"

require File.dirname(__FILE__) + "/eskimagic/core_features/base"
require File.dirname(__FILE__) + "/eskimagic/core_features/extra_validations"

ActionView::Base.send :include, EskimagicHelper
ActionView::Base.send :include, DateHelper
ActionView::Base.send :include, StringHelper
ActionView::Base.send :include, AdminHelper
ActionView::Base.send :include, SiteSettingsHelper
ActionView::Base::FormHelper.send :include, FormHelper
