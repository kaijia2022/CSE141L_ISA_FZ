#pragma once
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <map>
#include <stack>

using namespace std;

const string PAD_RR0 = "0000";
const string PAD_RR1 = "00";
const string PAD_RI0 = "000000";
const string PAD_RI1 = "000";
const string MOV_REG_2_MEM = "01001";
const string MOV_MEM_2_REG = "01010";

map<string, string> OpcodeMap_RR0 = {
	{"RET", "01100"},
	{"NOP", "11111"},
	{"TOG", "00000"},
	{"JE","00011"},
	{"JZ","00100"},
	{"JUMP", "00110"},
	{"CALL","01011"},
};

map<string, string> OpcodeMap_RR1 = {
	{"DEC", "00010"},
	{"RET","01100"},
	{"SHR","10001"},
	{"SRC","10010"},
	{"SHL","10011"},
	{"SLC","10100"},
	{"SHL","10011"},
	{"LEA", "01000"},
};

map<string, string> OpcodeMap_RR2 = {
	{"CMP", "00101"},
	{"MOV", "00001"},
	{"ADD", "00111"},
	{"SUB", "01110"},
	{"AND", "01111"},
	{"XOR", "10000"},
	{"OR", "10101"},
	{"ADDS", "10110"},
	{"SUBS", "10111"},
};

map<string, string> registerMap_RR = {
	{"RAS", "00"},
	{"RBS", "01"},
	{"RCS", "10"},
	{"RDS", "11"},
};

map<string, string> OpcodeMap_RI0 = {
	{"TOG", "000"},
	{"JE", "011"},
	{"JZ", "100"},
};

map<string, string> OpcodeMap_RI1 = {
	 {"DEC", "010"},

};

map<string, string> OpcodeMap_RI2 = {
	{"CMP", "101"},
	{"MOV", "001"},
	{"ADD", "111"},
};

map<string, string> registerMap_RI = {
	{"RAS", "000"},
	{"RBS", "001"},
	{"RCS", "010"},
	{"RDS", "011"},
	{"RES", "100"},
	{"RFS", "101"},
	{"RC1", "110"},
	{"RC2", "111"}
};

map<string, string> immediateMap_RI = {
	{"0", "000"},
	{"1", "001"},
	{"4", "010"},
	{"8", "011"},
	{"16", "100"},
	{"32", "101"},
	{"64", "110"},
	{"127", "111"}
};
vector<string> jumpOpcodes = { "JZ","JE", "CALL", "JUMP"};

string generateMachineCode(const vector<pair<int, pair<string, vector<string>>>>& instructions, int idx) {
	string result = "";
	string operand1 = "";
	string operand2 = "";
	int mode = instructions[idx].first;
	string opcode = instructions[idx].second.first;
	int numOperands = instructions[idx].second.second.size();
	if (mode) {
		switch (numOperands) {
		case 0:
			if (OpcodeMap_RI0.count(opcode)) {
				result.append(OpcodeMap_RI0.at(opcode));
				result.append(PAD_RI0);
			}
			break;
		case 1:
			operand1 = instructions[idx].second.second[0];
			if (OpcodeMap_RI1.count(opcode) && registerMap_RI.count(operand1)) {
				result.append(OpcodeMap_RI1.at(opcode));
				result.append(registerMap_RI.at(operand1));
				result.append(PAD_RI1);
			}
			break;
		case 2:
			operand1 = instructions[idx].second.second[0];
			operand2 = instructions[idx].second.second[1];
			if (OpcodeMap_RI2.count(opcode) && registerMap_RI.count(operand1) && immediateMap_RI.count(operand2)) {
				result.append(OpcodeMap_RI2.at(opcode));
				result.append(registerMap_RI.at(operand1));
				result.append(immediateMap_RI.at(operand2));
			}
			break;
		}
	}
	else {
		switch (numOperands) {
		case 0:
			if (OpcodeMap_RR0.count(opcode)) {
				result.append(OpcodeMap_RR0.at(opcode));
				result.append(PAD_RR0);
			}
			break;
		case 1:
			operand1 = instructions[idx].second.second[0];
			if (OpcodeMap_RR1.count(opcode) && registerMap_RR.count(operand1)) {
				result.append(OpcodeMap_RR1.at(opcode));
				result.append(registerMap_RR.at(operand1));
				result.append(PAD_RR1);
			}
			break;
		case 2:
			operand1 = instructions[idx].second.second[0];
			operand2 = instructions[idx].second.second[1];
			if (operand1.find("[") != string::npos && operand1.find("]") != string::npos) {
				result.append(MOV_REG_2_MEM);
				operand1 = operand1.substr(1, operand1.size() - 2);
			}
			else if (operand2.find("[") != string::npos && operand2.find("]") != string::npos) {
				result.append(MOV_MEM_2_REG);
				operand2 = operand2.substr(1, operand2.size() - 2);
			}
			else {
				result.append(OpcodeMap_RR2.at(opcode));
			}
			result.append(registerMap_RR.at(operand1));
			result.append(registerMap_RR.at(operand2));

			break;
		}
	}
	return result;

}

string generateLookupTableAddress(const vector<pair<string, string>> lut, int idx) {
	string result = "";
	string jumpAddr = lut[idx].first;
	result.append(jumpAddr);
	return result;
}

string generateLookupTableOffset(const vector<pair<string, string>> lut, int idx) {
	string result = "";
	string offset = lut[idx].second;
	result.append(offset);
	return result;
}

void parseAssembly(const string& inputFile, vector<pair<int, pair<string, vector<string>>>>& instructions, vector<pair<string, string>>& lut) {
	vector<pair<int, string>> jumpSrcDest;
	ifstream file(inputFile);
	string line;
	int mode = 0;
	while (getline(file, line)) {
		stringstream ss(line);
		string opcode;
		ss >> opcode;
		if (opcode.empty()) {
			continue;
		}
		if (opcode == "TOG") {
			if (mode == 1) {
				mode = 0;
				
			}
			else {
				mode = 1;
			}
		}
		if (opcode[0] == '_') {
			vector<int> sourceAddrs;
			for (pair<int, string> pair : jumpSrcDest) {
				if (opcode.find(pair.second) != string::npos) {
					sourceAddrs.push_back(pair.first);
				}
			}
			for (int addr : sourceAddrs) {
				string offset = to_string(instructions.size() + 1 - addr);
				string jumpInstruction = generateMachineCode(instructions, addr);
				mode = instructions[addr].first;
				lut.push_back(make_pair(jumpInstruction, offset));
			}

			continue;
		}
		vector<string> operands;
		string operand;
		auto it = find(jumpOpcodes.begin(), jumpOpcodes.end(), opcode);
		if (it != jumpOpcodes.end()) {
			string destination;
			ss >> destination;
			jumpSrcDest.push_back(make_pair(instructions.size(), destination));
		}
		else {
			while (ss >> operand) {
				operands.push_back(operand);
			}
		}
		
		instructions.emplace_back(mode, make_pair(opcode, operands));
	}
}

int main() {
	// Parse assembly code
	vector<pair<int, pair<string, vector<string>>>> instructions;
	vector<pair<string, string>> lut;
	parseAssembly("prog1_test.txt", instructions, lut);

	// Translate to machine code and generate output files
	ofstream machine_code("prog1_test_machine_code.txt");
	ofstream Jump_Instructions("Jump_Instructions.txt");
	ofstream offsets("offsets.txt");

	for (int i = 0; i < instructions.size(); i++) {
		string machineCode = generateMachineCode(instructions, i);
		cout << "Line: " << i << endl;
		machine_code << machineCode << endl;
	}

	for (int i = 0; i < lut.size(); i++) {
		string row = generateLookupTableAddress(lut, i);
		Jump_Instructions << row << endl;
	}
	for (int i = 0; i < lut.size(); i++) {
		string row = generateLookupTableOffset(lut, i);
		offsets << row << endl;
	}
	machine_code.close();
	Jump_Instructions.close();
	offsets.close();
	return 0;
}