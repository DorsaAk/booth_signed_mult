
`timescale 1ns/1ns

module nb_even_booth_tb();

   parameter no_of_tests = 100;
   parameter nb = 12;

//------------------generating clock signal in 100MHz
   reg clk = 1'b1;
   always @(clk)
      clk <= #5 ~clk;
//-----------------------------------------------------
 
//-------------------------------------- reg declaration 
   reg start;
   reg signed [(nb -1) : 0] A, B, C, D;
   reg signed [(2*nb -1) : 0] expected_product;
//----------------------------------------------------------    
   integer i, j, err = 0;

   initial begin
      $dumpfile("waveform.vcd");
      $dumpvars(0, nb_even_booth_tb);
   end
   
   initial begin
      start = 0;

      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1;
//------------------------------------------repeat the test no_of_tests times with different random numbers
      for(i=0; i<no_of_tests; i=i+1) begin

         A = $random();    
         B = $random();
         expected_product = A * B;
         C = A;
         D = B;
      //----------------------------------generating start signal -------------------------------------------------------------     
         start = 1;
         @(posedge clk);
         #1;
         start = 0;
         A = 'bx; //When start became "1" we register A & B and their changes is not important after start became "0"
         B = 'bx; //When start became "1" we register A & B and their changes is not important after start became "0"
      //----------------------------------------------------------------------------------------------------------------------
         
      //-----------------------------------wait until multiplication become complete
         for(j=0; j<=nb; j=j+1)        
            @(posedge clk);
         @(posedge clk);
      //------------------------------------------------------------------------------

         $write   ("%x (%0d) x %x (%0d) = %x (%0d) ", C, C, D, D, uut.PP_Result_Multiplier, $signed(uut.PP_Result_Multiplier));

         if (expected_product === uut.PP_Result_Multiplier)
            $display(", OK");
         else 
            $display (", ERROR: expected %x, got %x", expected_product, uut.PP_Result_Multiplier); 

      end

      $stop;
   end


    nb_even_booth uut (
        .clk(clk),
        .start(start),
        .A(A),
        .B(B),
        .PP_Result_Multiplier(),
        .ready()
    );


endmodule