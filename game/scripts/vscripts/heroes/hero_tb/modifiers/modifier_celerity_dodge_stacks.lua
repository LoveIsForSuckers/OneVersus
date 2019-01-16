if modifier_celerity_dodge_stacks == nil then
	modifier_celerity_dodge_stacks = class({})
end

function modifier_celerity_dodge_stacks:IsHidden()
	return true
end

function modifier_celerity_dodge_stacks:IsDebuff()
	return false
end

function modifier_celerity_dodge_stacks:IsPurgable()
	return true
end

function modifier_celerity_dodge_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
	
	return funcs
end

function modifier_celerity_dodge_stacks:GetModifierEvasion_Constant()
	return self:GetStackCount()
end