module NewIssueView
  module IssuesHelperPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
      end
    end

    module InstanceMethods
      def modified_link_to_issue(issue, options={})
        title = nil
        subject = nil
        text = options[:tracker] == false ? "##{issue.id}" : "#{issue.tracker} ##{issue.id}:"
        if options[:subject] == false
          title = issue.subject.truncate(60)
        else
          subject = issue.subject
          if truncate_length = options[:truncate]
            subject = subject.truncate(truncate_length)
          end
        end
        only_path = options[:only_path].nil? ? true : options[:only_path]
        s = link_to(text, issue_path(issue, :only_path => only_path),
                    :class => issue.css_classes, :title => title)
        s << link_to(" #{subject}", issue_path(issue, :only_path => only_path), :title => title ) if subject
        s = h("#{issue.project} - ") + s if options[:project]
        s
      end
    end
  end
end

# Add module to Query
unless IssuesHelper.included_modules.include?(NewIssueView::IssuesHelperPatch)
  IssuesHelper.send(:include, NewIssueView::IssuesHelperPatch)
end
