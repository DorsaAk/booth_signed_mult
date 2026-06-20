`timescale 1ns/1ns

module nb_even_odd_booth(clk, start, A, B, PP_Result_Multiplier, ready);

//-----------------------Port directions and deceleration
   parameter n = 11;

   parameter nb = (n % 2 == 0) ? n : n + 1;

   input clk;
   input start;
   input signed [n - 1 : 0] A;
   input signed [n  - 1 : 0] B; 
   output reg [2 * nb - 1 : 0] PP_Result_Multiplier;
   output ready;


//------------------------------------------------------

//----------------------------------- register deceleration

reg prev_bit;
reg signed [nb - 1 : 0] Multiplicand;
// reg [$clog2(nb) / 2 : 0]  counter; //am i right?!
reg [$clog2(nb / 2 + 1) : 0]  counter;

//-------------------------------------------------------

//------------------------------------- wire deceleration

reg signed [nb + 1 : 0] adder_output;
wire signed [nb : 0] negated_A;
wire signed [nb + 1 : 0] negated_2A;
wire signed [nb + 1 : 0] positive_2A;

//---------------------------------------------------------

//-------------------------------------- combinational logic

assign ready = (counter == nb / 2);
assign negated_A = ~Multiplicand + 1;
assign negated_2A = ~(Multiplicand << 1) + 1;
assign positive_2A = Multiplicand << 1;

//---------------------------------------------------------

always @(*) begin
    if(PP_Result_Multiplier[1:0] == 2'b00) begin
            if(prev_bit == 1'b0) //0
                adder_output = {PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1 : nb]};
            else //A
                adder_output = {PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1 : nb]} + {Multiplicand[nb - 1], Multiplicand[nb - 1], Multiplicand};
      end
      else if(PP_Result_Multiplier[1:0] == 2'b01) begin
            if(prev_bit == 1'b0) //A
                adder_output = {PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2 * nb - 1 : nb]} + {Multiplicand[nb - 1], Multiplicand[nb - 1], Multiplicand};
            else //2A
                adder_output = {PP_Result_Multiplier[2 * nb - 1], PP_Result_Multiplier[2 * nb - 1], PP_Result_Multiplier[2*nb - 1 : nb]} + {positive_2A};
      end
      else if(PP_Result_Multiplier[1:0] == 2'b10) begin
            if(prev_bit == 1'b0) //-2A
                adder_output = {PP_Result_Multiplier[2 * nb - 1], PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1 : nb]} + {negated_2A};
            else //-A
                adder_output = {PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1 : nb]} + {negated_A[nb - 1], negated_A};
      end
      //else if(PP_Result_Multiplier[1:0] == 2'b11) begin
      else begin  
            if(prev_bit == 1'b0) //-A
                adder_output = {PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1 : nb]} + {negated_A[nb - 1], negated_A};
            else //0
                adder_output = {PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1], PP_Result_Multiplier[2*nb - 1 : nb]};
      end
end

//--------------------------------------- sequential Logic

always @ (posedge clk)

   if(start) begin
      prev_bit <= 0;
      counter <= 0;
      //Multiplier <= B;
      if (n == nb)
        Multiplicand <= A;
      else
        Multiplicand <= {A[n-1], A};
      
      if (n == nb)
        PP_Result_Multiplier <= {{nb{1'b0}}, B};
      else
        PP_Result_Multiplier <= {{nb{1'b0}}, B[n-1], B};
    end

   else if(!ready) begin

      counter <= counter + 1;
      prev_bit <= PP_Result_Multiplier[1];
      PP_Result_Multiplier <= {adder_output, PP_Result_Multiplier[nb - 1 : 2]};
   end 
endmodule
