json.array!(@edm_tasks) do |edm_task|
  json.extract! edm_task, :id, :title, :content
  json.url edm_task_url(edm_task, format: :json)
end
