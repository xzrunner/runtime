require "gui"
local base = require "shaderlab.nodes.base"
local interface = require "shaderlab.nodes.interface"
local parser = require "shaderlab.grammarparser"

local M = setmetatable({}, base)
M.__index = M

local WIDTH = 100
local TOT_HEIGHT = 75
local ITEM_HEIGHT = 25

local ID = 1

function M:initialize(x, y)
	base.initialize(self)

	self.type = "max"
	self.name = "max_" .. ID
	ID = ID + 1

	local frame = gui.create("frame")
	self.output = interface.create(frame, self, "out", "")
	frame:SetTitle("Max"):SetSize(WIDTH, TOT_HEIGHT):SetPos(x, y)
	self.frame = frame

	local panel = gui.create("panel", frame)
	self.input[1] = interface.create(panel, self, "in")
	panel:SetSize():SetSize(WIDTH, ITEM_HEIGHT):SetPos(0, ITEM_HEIGHT)
	local text = gui.create("text", panel)
	text:SetPos(12, 5):SetText("Operand A")

	local panel = gui.create("panel", frame)
	self.input[2] = interface.create(panel, self, "in")	
	panel:SetSize():SetSize(WIDTH, ITEM_HEIGHT):SetPos(0, ITEM_HEIGHT+ITEM_HEIGHT)
	local text = gui.create("text", panel)
	text:SetPos(12, 5):SetText("Operand B")	
end

function M:ToCode()
	local in1 = self.input[1].connected[1]
	local in2 = self.input[2].connected[1]
	if in1 and in2 then
		local datatype = self:GetDataType()
		local name1 = in1:GetNode():GetName()
		local name2 = in2:GetNode():GetName()
		return datatype .. " " .. self.name .. " = max(" .. name1 .. ", " .. name2 .. ");"
	else
		return ""
	end
end

function M:GetDataType()
	local in1 = self.input[1].connected[1]
	local in2 = self.input[2].connected[1]
	if in1 and in2 then
		local type1 = in1:GetNode():GetDataType()
		local type2 = in2:GetNode():GetDataType()
		assert(type1 == type2, "two types not equal")
		return type1		
	else
		return ""
	end
end

function M:Connected()
	local in1 = self.input[1].connected[1]
	local in2 = self.input[2].connected[1]
	if in1 and in2 then
		local name1 = in1:GetNode():GetName()
		local name2 = in2:GetNode():GetName()
		parser.add(self.name, name1, name2, "max")		
	end	
end

function M:Deconnected()
	parser.remove(self.name)
end

return M