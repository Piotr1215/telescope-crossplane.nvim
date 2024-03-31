local crossplane = require('telescope._extensions.telescope-crossplane')
local stub = require('luassert.stub')
local spy = require('luassert.spy')

describe('telescope-crossplane', function()
  describe('get_resources', function()
    it('should fetch and parse resources', function()
      local fake_kubectl_output = 'pod/nginx\npod/redis'
      local system_stub = stub(vim.fn, 'system', fake_kubectl_output)
      local resources = crossplane.get_resources('kubectl get pods')
      assert.stub(system_stub).was_called_with('kubectl get pods')
      assert.is_not_nil(resources)
      assert.are.same({ 'pod/nginx', 'pod/redis' }, resources)
      system_stub:revert()
    end)
  end)

  describe('edit_resource', function()
    -- This test will be removed as it requires telescope and mocking
  end)

  describe('show_resources', function()
    -- This test will be removed as it requires telescope
  end)

  describe('show_managed_resources', function()
    -- This test will be removed as it requires telescope
  end)

  describe('show_crossplane_resources', function()
    -- This test will be removed as it requires telescope
  end)
end)
