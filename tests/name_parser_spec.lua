local name_parser = require("buffer-list.ui.name-parser")

describe("Name Parser Module", function()
  it("should extract filename for single buffer", function()
    local buffers = {
      { id = 1, path = { "", "home", "user", "project", "awesome.lua" } },
    }

    local result = name_parser.parseBuffers(buffers)

    assert.are.same(result, {
      { id = 1, name = "awesome.lua" },
    })
  end)

  it("should handle empty path as [No Name]", function()
    local buffers = {
      { id = 1, path = { "" } },
    }

    local result = name_parser.parseBuffers(buffers)

    assert.are.same(result, {
      { id = 1, name = "[No Name]" },
    })
  end)

  it("should number multiple unnamed buffers (Example 3)", function()
    local buffers = {
      { id = 1, path = { "" } },
      { id = 2, path = { "" } },
    }

    local result = name_parser.parseBuffers(buffers)

    assert.are.same(result, {
      { id = 1, name = "[No Name] 1" },
      { id = 2, name = "[No Name] 2" },
    })
  end)

  describe("Name Conflict Resolution", function()
    it("should resolve conflict using first differing directory component (Example 1)", function()
      local buffers = {
        { id = 1, path = { "", "home", "test", "project", "file.lua" } },
        { id = 2, path = { "", "home", "exam", "project", "file.lua" } },
      }

      local result = name_parser.parseBuffers(buffers)

      assert.are.same(result, {
        { id = 1, name = "test/file.lua" },
        { id = 2, name = "exam/file.lua" },
      })
    end)

    it("should resolve conflict using first differing directory component (Example 2)", function()
      local buffers = {
        { id = 1, path = { "", "home", "agua", "project", "test", "file.lua" } },
        { id = 2, path = { "", "home", "rosa", "project", "exam", "file.lua" } },
      }

      local result = name_parser.parseBuffers(buffers)

      assert.are.same(result, {
        { id = 1, name = "agua/file.lua" },
        { id = 2, name = "rosa/file.lua" },
      })
    end)

    it("should resolve conflict when one file has shorter path (Example 4)", function()
      local buffers = {
        { id = 1, path = { "", "home", "file.lua" } },
        { id = 2, path = { "", "home", "rosa", "file.lua" } },
      }

      local result = name_parser.parseBuffers(buffers)

      assert.are.same(result, {
        { id = 1, name = "file.lua" },
        { id = 2, name = "rosa/file.lua" },
      })
    end)

    it("should resolve conflict for 3 files with unique directory component (Example 5.1)", function()
      local buffers = {
        { id = 1, path = { "", "home", "agua", "project", "test", "file.lua" } },
        { id = 2, path = { "", "home", "rosa", "project", "exam", "file.lua" } },
        { id = 3, path = { "", "home", "pata", "project", "exam", "file.lua" } },
      }

      local result = name_parser.parseBuffers(buffers)

      assert.are.same(result, {
        { id = 1, name = "agua/file.lua" },
        { id = 2, name = "rosa/file.lua" },
        { id = 3, name = "pata/file.lua" },
      })
    end)

    it("should resolve conflict for 3 files with branching directories (Example 5.2)", function()
      local buffers = {
        { id = 1, path = { "", "home", "agua", "project", "test", "file.lua" } },
        { id = 2, path = { "", "home", "rosa", "git", "exam", "file.lua" } },
        { id = 3, path = { "", "home", "rosa", "scm", "exam", "file.lua" } },
      }

      local result = name_parser.parseBuffers(buffers)

      assert.are.same(result, {
        { id = 1, name = "agua/file.lua" },
        { id = 2, name = "rosa/git/file.lua" },
        { id = 3, name = "rosa/scm/file.lua" },
      })
    end)
  end)
end)
