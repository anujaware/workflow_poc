class Workflow < ApplicationRecord
  mount_uploader :bpmn_diagram_file, AttachmentUploader
  mount_uploader :bpmn_image, AttachmentUploader
end
