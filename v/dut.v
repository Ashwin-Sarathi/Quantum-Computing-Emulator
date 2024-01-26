`include "defines.vh"

//---------------------------------------------------------------------------
//FSM registers for q_input_state
  `ifndef FSM_BIT_WIDTH
    `define FSM_BIT_WIDTH 4
  `endif

 // Use define to parameterize the variable sizes
  `ifndef SRAM_ADDR_WIDTH
    `define SRAM_ADDR_WIDTH 32
  `endif

  `ifndef SRAM_DATA_WIDTH
    `define SRAM_DATA_WIDTH 64
  `endif 

//---------------------------------------------------------------------------
// DUT 
//---------------------------------------------------------------------------
module MyDesign(
//---------------------------------------------------------------------------
//System signals
  input wire reset_n                      ,  
  input wire clk                          ,

//---------------------------------------------------------------------------
//Control signals
  input wire dut_valid                    , 
  output wire dut_ready                   ,

//---------------------------------------------------------------------------
//q_state_input SRAM interface
  output wire                                               q_state_input_sram_write_enable  ,
  output wire [`Q_STATE_INPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_input_sram_write_address ,
  output wire [`Q_STATE_INPUT_SRAM_DATA_UPPER_BOUND-1:0]    q_state_input_sram_write_data    ,
  output wire [`Q_STATE_INPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_input_sram_read_address  , 
  input  wire [`Q_STATE_INPUT_SRAM_DATA_UPPER_BOUND-1:0]    q_state_input_sram_read_data     ,

//---------------------------------------------------------------------------
//q_state_output SRAM interface
  output wire                                                q_state_output_sram_write_enable  ,
  output wire [`Q_STATE_OUTPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_output_sram_write_address ,
  output wire [`Q_STATE_OUTPUT_SRAM_DATA_UPPER_BOUND-1:0]    q_state_output_sram_write_data    ,
  output wire [`Q_STATE_OUTPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_output_sram_read_address  , 
  input  wire [`Q_STATE_OUTPUT_SRAM_DATA_UPPER_BOUND-1:0]    q_state_output_sram_read_data     ,

//---------------------------------------------------------------------------
//scratchpad SRAM interface                                                       
  output wire                                                scratchpad_sram_write_enable        ,
  output wire [`SCRATCHPAD_SRAM_ADDRESS_UPPER_BOUND-1:0]     scratchpad_sram_write_address       ,
  output wire [`SCRATCHPAD_SRAM_DATA_UPPER_BOUND-1:0]        scratchpad_sram_write_data          ,
  output wire [`SCRATCHPAD_SRAM_ADDRESS_UPPER_BOUND-1:0]     scratchpad_sram_read_address        , 
  input  wire [`SCRATCHPAD_SRAM_DATA_UPPER_BOUND-1:0]        scratchpad_sram_read_data           ,

//---------------------------------------------------------------------------
//q_gates SRAM interface                                                       
  output wire                                                q_gates_sram_write_enable           ,
  output wire [`Q_GATES_SRAM_ADDRESS_UPPER_BOUND-1:0]        q_gates_sram_write_address          ,
  output wire [`Q_GATES_SRAM_DATA_UPPER_BOUND-1:0]           q_gates_sram_write_data             ,
  output wire [`Q_GATES_SRAM_ADDRESS_UPPER_BOUND-1:0]        q_gates_sram_read_address           ,  
  input  wire [`Q_GATES_SRAM_DATA_UPPER_BOUND-1:0]           q_gates_sram_read_data              
);

//------------------------------------------------------------------------------------------
//q_state_input SRAM interface
  reg                                               q_state_input_sram_write_enable_r  ;
  reg [`Q_STATE_INPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_input_sram_read_address_r  ;

//q_gates SRAM interface
  reg                                               q_gates_sram_write_enable_r  ;
  reg [`Q_STATE_INPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_gates_sram_read_address_r  ;

//scratchpad SRAM interface
  reg                                               scratchpad_sram_write_enable_r  ;
  reg [`Q_STATE_INPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] scratchpad_sram_write_address_r ;
  reg [`Q_STATE_INPUT_SRAM_DATA_UPPER_BOUND-1:0]    scratchpad_sram_write_data_r    ;
  reg [`Q_STATE_INPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] scratchpad_sram_read_address_r  ;

//q_state_output SRAM interface
  reg                                               q_state_output_sram_write_enable_r  ;
  reg [`Q_STATE_INPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_output_sram_write_address_r ;
  reg [`Q_STATE_INPUT_SRAM_DATA_UPPER_BOUND-1:0]    q_state_output_sram_write_data_r    ;
  reg [`Q_STATE_INPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_output_sram_read_address_r  ;


//------------------------------------------------------------------------------------------
//MAC arguments
  localparam inst_sig_width_mac = 52;
  localparam inst_exp_width_mac = 11;
  localparam inst_ieee_compliance_mac = 1;

  reg  [inst_sig_width_mac+inst_exp_width_mac : 0] inst_a1;
  reg  [inst_sig_width_mac+inst_exp_width_mac : 0] inst_b1;
  reg  [inst_sig_width_mac+inst_exp_width_mac : 0] inst_c1;
  reg  [inst_sig_width_mac+inst_exp_width_mac : 0] inst_a2;
  reg  [inst_sig_width_mac+inst_exp_width_mac : 0] inst_b2;
  reg  [inst_sig_width_mac+inst_exp_width_mac : 0] inst_c2;
  reg  [2 : 0] inst_rnd_mac;
  wire [inst_sig_width_mac+inst_exp_width_mac : 0] z_inst_mac1;
  wire [inst_sig_width_mac+inst_exp_width_mac : 0] z_inst_mac2;
  wire [7 : 0] status_inst_mac1;
  wire [7 : 0] status_inst_mac2;


//Adder arguments
  localparam inst_sig_width_adder = 52;
  localparam inst_exp_width_adder = 11;
  localparam inst_ieee_compliance_adder = 1;

  reg  [inst_sig_width_adder+inst_exp_width_adder : 0] inst_a3;
  reg  [inst_sig_width_adder+inst_exp_width_adder : 0] inst_b3;
  reg  [inst_sig_width_adder+inst_exp_width_adder : 0] inst_a4;
  reg  [inst_sig_width_adder+inst_exp_width_adder : 0] inst_b4;
  reg  [2 : 0] inst_rnd_adder;
  wire [inst_sig_width_adder+inst_exp_width_adder : 0] z_inst_adder1;
  wire [inst_sig_width_adder+inst_exp_width_adder : 0] z_inst_adder2;
  wire [7 : 0] status_inst_adder1;
  wire [7 : 0] status_inst_adder2;


  // This is test stub for passing input/outputs to a DP_fp_mac, there many
  // more DW macros that you can choose to use
  // DW_fp_mac_inst FP_MAC1 ( 
  //   inst_a,
  //   inst_b,
  //   inst_c,
  //   inst_rnd,
  //   z_inst,
  //   status_inst
  // );

//------------------------------------------------------------------------------------------
  parameter [`FSM_BIT_WIDTH-1 : 0]
    S0  = `FSM_BIT_WIDTH'b0000,
    S1  = `FSM_BIT_WIDTH'b0001,
    S2  = `FSM_BIT_WIDTH'b0010,
    S3  = `FSM_BIT_WIDTH'b0011,    
    S4  = `FSM_BIT_WIDTH'b0100,
    S5  = `FSM_BIT_WIDTH'b0101,
    S6  = `FSM_BIT_WIDTH'b0110,
    S7  = `FSM_BIT_WIDTH'b0111,
    S8  = `FSM_BIT_WIDTH'b1000,
    S9  = `FSM_BIT_WIDTH'b1001,
    S10 = `FSM_BIT_WIDTH'b1010;

  reg [`FSM_BIT_WIDTH-1 : 0] current_state, next_state;

//------------------------------------------------------------------------------------------ 
// Local control path variables
  reg                           set_dut_ready                  ;
  reg                           get_q_m                        ;
  reg                           save_q_m                       ;
  reg [1:0]                     q_state_input_read_addr_sel    ;
  reg [1:0]			q_gates_read_addr_sel          ;
  reg [1:0]                     scratchpad_read_addr_sel       ;
  reg [1:0]                     q_state_output_write_addr_sel  ;
  reg [1:0]                     sram_write_enable_sel          ;
  reg [1:0]			scratchpad_address_controller  ;
  reg 				input_sram_sel		       ;
  reg [1:0]                     compute_mac	               ;
  reg 				compute_adder		       ;
  reg 				row_read_complete	       ;
  reg				gate_read_complete	       ;
  reg				matrix_read_complete	       ;
  reg [1:0]			matrix_count_controller	       ;
  reg				final_matrix_check	       ;
  reg [1:0]			temp_addend_control            ;
  reg [1:0]			temp_adder_control	       ;
  reg 				compute_complete	       ;

// Local data path variables 
  reg [`SRAM_DATA_WIDTH-1:0]      q_states_count              ;
  reg [`SRAM_DATA_WIDTH-1:0]      gates_count          	      ;
  reg [`SRAM_DATA_WIDTH-1:0]	  scratchpad_address_counter  ;
  reg [`SRAM_DATA_WIDTH-1:0]      matrix_count         	      ;
  reg [`SRAM_DATA_WIDTH-1:0]	  total_matrices	      ;
  reg [`SRAM_DATA_WIDTH-1:0]      temp_mac1                   ;
  reg [`SRAM_DATA_WIDTH-1:0]      temp_mac2                   ;
  reg [`SRAM_DATA_WIDTH-1:0]      temp_adder1                 ;
  reg [`SRAM_DATA_WIDTH-1:0]      temp_adder2                 ;

// -------------------- Control path ------------------------
  always @(posedge clk) begin : proc_current_state_fsm
    if(!reset_n) begin // Synchronous reset
      current_state <= S0;
    end 
    else begin
      current_state <= next_state;
    end
  end

  always @(*) begin : proc_next_state_fsm
    case (current_state)
      S0                      : begin
        if (dut_valid) begin
          set_dut_ready       		          = 1'b0 ;
          get_q_m             		          = 1'b1 ;
          save_q_m            	  	          = 1'b0 ;
          q_state_input_read_addr_sel             = 2'b00;
          q_gates_read_addr_sel       	          = 2'b00;
	  scratchpad_read_addr_sel		  = 2'b00;
          q_state_output_write_addr_sel           = 2'b00;
          sram_write_enable_sel                   = 2'b00;
	  scratchpad_address_controller		  = 2'b00;
	  matrix_count_controller		  = 2'b00;
  	  input_sram_sel		          = 1'b0 ;
          compute_mac		    	          = 2'b00;
	  compute_adder				  = 1'b0 ;
	  temp_addend_control		          = 2'b00;
	  temp_adder_control			  = 2'b00;
          next_state          		          = S1   ; 
        end
        else begin
	  set_dut_ready       		          = 1'b1 ;
          get_q_m             		          = 1'b0 ;
          save_q_m            	  	          = 1'b0 ;
          q_state_input_read_addr_sel             = 2'b00;
          q_gates_read_addr_sel       	          = 2'b00;
	  scratchpad_read_addr_sel		  = 2'b00;
          q_state_output_write_addr_sel           = 2'b00;
          sram_write_enable_sel                   = 2'b00;
	  scratchpad_address_controller		  = 2'b00;
	  matrix_count_controller		  = 2'b00;
  	  input_sram_sel		          = 1'b0 ;
          compute_mac		    	          = 2'b00;
	  compute_adder				  = 1'b0 ;
	  temp_addend_control		          = 2'b00;
	  temp_adder_control			  = 2'b00;
          next_state          		          = S0   ;
        end
      end
    
      S1                        :  begin
	set_dut_ready       		          = 1'b0 ;
        get_q_m             		          = 1'b0 ;
        save_q_m            	  	          = 1'b1 ;
        q_state_input_read_addr_sel               = 2'b01;
        q_gates_read_addr_sel       	          = 2'b00;
	scratchpad_read_addr_sel		  = 2'b00;
        q_state_output_write_addr_sel             = 2'b00;
        sram_write_enable_sel                     = 2'b00;
	scratchpad_address_controller		  = 2'b00;
	matrix_count_controller		          = 2'b00;
  	input_sram_sel		                  = 1'b0 ;
        compute_mac			          = 2'b00;
	compute_adder				  = 1'b0 ;
        temp_addend_control		          = 2'b00;
	temp_adder_control			  = 2'b00;
        next_state          		          = S2   ;
      end

      S2                        :  begin
	set_dut_ready       		          = 1'b0 ;
        get_q_m             		          = 1'b0 ;
        save_q_m            	  	          = 1'b1 ;
        q_state_input_read_addr_sel               = 2'b10;
        q_gates_read_addr_sel       	          = 2'b10;
	scratchpad_read_addr_sel		  = 2'b10;
        q_state_output_write_addr_sel             = 2'b10;
        sram_write_enable_sel                     = 2'b00;
	scratchpad_address_controller		  = 2'b10;
	matrix_count_controller		          = 2'b10;
	if (!matrix_count)
	  input_sram_sel			  = 1'b0 ;
	else
	  input_sram_sel			  = 1'b1 ;
        compute_mac			          = 2'b00;
	compute_adder				  = 1'b0 ;
        temp_addend_control		          = 2'b00;
	temp_adder_control			  = 2'b01;
        next_state          		          = S3   ;
      end

      S3                        :  begin
	set_dut_ready       		          = 1'b0 ;
        get_q_m             		          = 1'b0 ;
        save_q_m            	  	          = 1'b1 ;
        q_state_input_read_addr_sel               = 2'b10;
        q_gates_read_addr_sel       	          = 2'b10;
	scratchpad_read_addr_sel		  = 2'b10;
        q_state_output_write_addr_sel             = 2'b10;
        sram_write_enable_sel                     = 2'b00;
	scratchpad_address_controller		  = 2'b10;
	matrix_count_controller		          = 2'b10;
	if (!matrix_count)
	  input_sram_sel			  = 1'b0 ;
	else
	  input_sram_sel			  = 1'b1 ;
        compute_mac			          = 2'b01;
	compute_adder				  = 1'b0 ;
        temp_addend_control		          = 2'b00;
	temp_adder_control			  = 2'b10;
        next_state          		          = S4   ;
      end

      S4                        :  begin
	set_dut_ready       		          = 1'b0 ;
        get_q_m             		          = 1'b0 ;
        save_q_m            	  	          = 1'b1 ;
        q_state_input_read_addr_sel               = 2'b10;
        q_gates_read_addr_sel       	          = 2'b10;
	scratchpad_read_addr_sel		  = 2'b10;
        q_state_output_write_addr_sel             = 2'b10;
        sram_write_enable_sel                     = 2'b00;
	scratchpad_address_controller		  = 2'b10;
	matrix_count_controller		          = 2'b10;
	if (!matrix_count)
	  input_sram_sel			  = 1'b0 ;
	else
	  input_sram_sel			  = 1'b1 ;
        compute_mac			          = 2'b00;
	compute_adder				  = 1'b0 ;
        temp_addend_control		          = 2'b01;
	temp_adder_control			  = 2'b10;
        next_state				  = S5   ;
      end

      S5                        :  begin
	set_dut_ready       		          = 1'b0 ;
        get_q_m             		          = 1'b0 ;
        save_q_m            	  	          = 1'b1 ;
        q_state_input_read_addr_sel               = 2'b10;
        q_gates_read_addr_sel       	          = 2'b10;
	scratchpad_read_addr_sel		  = 2'b10;
        q_state_output_write_addr_sel             = 2'b10;
        sram_write_enable_sel                     = 2'b00;
	scratchpad_address_controller		  = 2'b10;
	matrix_count_controller		          = 2'b10;
	if (!matrix_count)
	  input_sram_sel			  = 1'b0 ;
	else
	  input_sram_sel			  = 1'b1 ;
        compute_mac			          = 2'b10;
	compute_adder				  = 1'b0 ;
        temp_addend_control		          = 2'b10;
	temp_adder_control			  = 2'b10;
        next_state 				  = S6   ;
      end


      S6                        :  begin
	set_dut_ready       		          = 1'b0 ;
        get_q_m             		          = 1'b0 ;
        save_q_m            	  	          = 1'b1 ;
        q_state_output_write_addr_sel             = 2'b10;
        sram_write_enable_sel                     = 2'b00;
	if (!matrix_count)
	  input_sram_sel			  = 1'b0 ;
	else
	  input_sram_sel			  = 1'b1 ;
        compute_mac			          = 2'b00;
	compute_adder				  = 1'b1 ;
        temp_addend_control		          = 2'b00;
	temp_adder_control			  = 2'b10;
	matrix_count_controller		          = 2'b10;
	if (matrix_read_complete) begin
	  next_state 				  = S7   ;
	  q_state_input_read_addr_sel             = 2'b10;	
          q_gates_read_addr_sel       	  	  = 2'b10;
	  scratchpad_address_controller	  	  = 2'b10;
	  scratchpad_read_addr_sel		  = 2'b10;
	end
	else begin
          if (row_read_complete) begin
	    next_state 				  = S7   ;
	    q_state_input_read_addr_sel           = 2'b10;	
            q_gates_read_addr_sel       	  = 2'b10;
	    scratchpad_address_controller	  = 2'b10;
	    scratchpad_read_addr_sel		  = 2'b10;
	  end
	  else begin
	    next_state				  = S2   ;
	    q_state_input_read_addr_sel           = 2'b01;
            q_gates_read_addr_sel       	  = 2'b01;  
	    scratchpad_address_controller 	  = 2'b10;
	    scratchpad_read_addr_sel		  = 2'b01;
	  end
	end
      end

      S7		      :  begin
	set_dut_ready       		          = 1'b0 ;
        get_q_m             		          = 1'b0 ;
        save_q_m            	  	          = 1'b1 ;	
	q_state_input_read_addr_sel           	  = 2'b10;
	if (!matrix_count)
	  input_sram_sel			  = 1'b0 ;
	else
	  input_sram_sel			  = 1'b1 ;
        q_gates_read_addr_sel       	          = 2'b10;
	scratchpad_address_controller		  = (gate_read_complete) ? 2'b00 : 2'b01;
	matrix_count_controller		          = 2'b10;
	scratchpad_read_addr_sel		  = 2'b10;
        q_state_output_write_addr_sel             = 2'b10;
        sram_write_enable_sel                     = (final_matrix_check) ? 2'b10 : 2'b01;
        compute_mac			          = 2'b00;
	compute_adder				  = 1'b0 ;
        temp_addend_control		          = 2'b10;
	temp_adder_control			  = 2'b10;
	next_state				  = S8   ;
      end

      S8		      :  begin
	set_dut_ready       		          = 1'b0 ;
        get_q_m             		          = 1'b0 ;
        save_q_m            	  	          = 1'b1 ;
	input_sram_sel				  = 1'b0 ;
        q_state_output_write_addr_sel             = (final_matrix_check) ? 2'b01 : 2'b00;
        sram_write_enable_sel                     = 2'b00;
        scratchpad_address_controller		  = 2'b10;
	matrix_count_controller		          = (matrix_read_complete) ? 2'b01 : 2'b10;
        compute_mac			          = 2'b00;
	compute_adder				  = 1'b0 ;
        temp_addend_control		          = 2'b10;
	temp_adder_control			  = 2'b10;
	if (gate_read_complete) begin
	  next_state				  = S0   ;
	  q_state_input_read_addr_sel             = 2'b00;
          q_gates_read_addr_sel       	          = 2'b10;
	  scratchpad_read_addr_sel		  = 2'b00;
	end
	else begin
	  next_state				  = S2   ;
	  q_state_input_read_addr_sel             = 2'b11;
          q_gates_read_addr_sel       	  	  = 2'b01;
	  scratchpad_read_addr_sel		  = (matrix_count) ? ((matrix_read_complete) ? 2'b01 : 2'b11) : 2'b00;	end  
      end

      default                 :  begin
	set_dut_ready       		          = 1'b1 ;
        get_q_m             		          = 1'b0 ;
        save_q_m            	  	          = 1'b0 ;
	input_sram_sel				  = 1'b0 ;
        q_state_input_read_addr_sel               = 2'b00;
        q_gates_read_addr_sel       	          = 2'b00;
	scratchpad_read_addr_sel	          = 2'b00;
        q_state_output_write_addr_sel             = 2'b00;
        sram_write_enable_sel     	          = 2'b00;
	scratchpad_address_controller		  = 2'b00;
	matrix_count_controller			  = 2'b00;
        compute_mac			          = 2'b00;
	compute_adder				  = 1'b0 ;
        temp_addend_control		          = 2'b00;
	temp_adder_control			  = 2'b00;
        next_state          		          = S0;
      end
    endcase
  end

  // DUT ready handshake logic
  always @(posedge clk) begin : proc_compute_complete
    if(!reset_n) begin
      compute_complete <= 0;
    end else begin
      compute_complete <= (set_dut_ready) ? 1'b1 : 1'b0;
    end
  end

  assign dut_ready = compute_complete;

  // Find the q_states and gates value and set matrix counter to 0
  always @(posedge clk) begin : proc_q_m
    if(!reset_n) begin
      q_states_count <= `SRAM_DATA_WIDTH'b0;
      gates_count    <= `SRAM_DATA_WIDTH'b0;
      total_matrices <= `SRAM_DATA_WIDTH'b0;
    end 
    else begin
      q_states_count <= get_q_m ? (2 ** q_state_input_sram_read_data[127:64]) : (save_q_m ? q_states_count : `SRAM_DATA_WIDTH'b0);
      gates_count    <= get_q_m ? ((2 ** q_state_input_sram_read_data[127:64]) * (2 ** q_state_input_sram_read_data[127:64]) * q_state_input_sram_read_data[63:0]) : (save_q_m ? gates_count : `SRAM_DATA_WIDTH'b0);
      total_matrices <= get_q_m ? (q_state_input_sram_read_data[63:0]) : (save_q_m ? total_matrices : `SRAM_DATA_WIDTH'b0);
    end
  end

  // Matrix count control
  always @(posedge clk) begin : matrix_count_control
    if(!reset_n)
      matrix_count <= `SRAM_DATA_WIDTH'b0;
    else begin
      if (matrix_count_controller == 2'b00)
	matrix_count <= `SRAM_DATA_WIDTH'b0;
      else if (matrix_count_controller == 2'b01)
	matrix_count <= matrix_count + 1;
      else 
	matrix_count <= matrix_count;
    end
  end

  // Read complete row in SRAM
  always @ (posedge clk) begin : read_row_complete
    if(!reset_n) begin
      row_read_complete <= 1'b0;
    end else begin
      row_read_complete <= (q_state_input_sram_read_address_r  == (q_states_count)) ? 1'b1 : 1'b0;
    end
  end

  // Read all gates in GATES SRAM
  always @ (posedge clk) begin : read_gate_complete
    if(!reset_n) begin
      gate_read_complete <= 1'b0;
    end else begin
      gate_read_complete <= (q_gates_sram_read_address_r  == (gates_count-1)) ? 1'b1 : 1'b0;
    end
  end

  // Read one full matrix
  always @(posedge clk) begin : read_matrix_complete
    if(!reset_n) begin
      matrix_read_complete <= 1'b0;
    end else begin
      matrix_read_complete <= (((q_gates_sram_read_address_r+1)%(q_states_count ** 2))  == 1'b0) ? 1'b1 : 1'b0;
    end
  end

  // Final Matrix Check
  always @(posedge clk) begin : check_if_final_matrix
    if(!reset_n) begin
      final_matrix_check <= 1'b0;
    end else begin
      final_matrix_check <= (matrix_count+1  == total_matrices) ? 1'b1 : 1'b0;
    end
  end

  // INPUT SRAM read address generator
  always @(posedge clk) begin
      if (!reset_n) begin
        q_state_input_sram_read_address_r   <= 0;
      end
      else begin
        if (q_state_input_read_addr_sel == 2'b00)
          q_state_input_sram_read_address_r <= `SRAM_ADDR_WIDTH'b0;
        else if (q_state_input_read_addr_sel == 2'b01)
          q_state_input_sram_read_address_r <= q_state_input_sram_read_address_r + `SRAM_ADDR_WIDTH'b1;
        else if (q_state_input_read_addr_sel == 2'b10)
          q_state_input_sram_read_address_r <= q_state_input_sram_read_address_r;
        else if (q_state_input_read_addr_sel == 2'b11)
          q_state_input_sram_read_address_r <= `SRAM_ADDR_WIDTH'b01;
      end
  end

  assign q_state_input_sram_read_address = q_state_input_sram_read_address_r;

  // GATES SRAM read address generator
  always @(posedge clk) begin
      if (!reset_n) begin
        q_gates_sram_read_address_r   <= 0;
      end
      else begin
        if (q_gates_read_addr_sel == 2'b00)
          q_gates_sram_read_address_r <= `SRAM_ADDR_WIDTH'b0;
        else if (q_gates_read_addr_sel == 2'b01)
          q_gates_sram_read_address_r <= q_gates_sram_read_address_r + `SRAM_ADDR_WIDTH'b1;
        else if (q_gates_read_addr_sel == 2'b10)
          q_gates_sram_read_address_r <= q_gates_sram_read_address_r;
        else if (q_gates_read_addr_sel == 2'b11)
          q_gates_sram_read_address_r <= `SRAM_ADDR_WIDTH'b01;
      end
  end

  assign q_gates_sram_read_address = q_gates_sram_read_address_r;

  // SCRATCHPAD SRAM read address generator
  always @(posedge clk) begin
      if (!reset_n) begin
        scratchpad_sram_read_address_r <= 0;
      end
      else begin
        if (scratchpad_read_addr_sel == 2'b00)
          scratchpad_sram_read_address_r <= `SRAM_ADDR_WIDTH'b0;
        else if (scratchpad_read_addr_sel == 2'b01)
          scratchpad_sram_read_address_r <= scratchpad_sram_read_address_r + `SRAM_ADDR_WIDTH'b1;
        else if (scratchpad_read_addr_sel == 2'b10)
          scratchpad_sram_read_address_r <= scratchpad_sram_read_address_r;
        else if (scratchpad_read_addr_sel == 2'b11)
          scratchpad_sram_read_address_r <= scratchpad_sram_read_address_r - (q_states_count - 1);
      end
  end

  assign scratchpad_sram_read_address = scratchpad_sram_read_address_r;

  // SRAM write enable logic
  always @(posedge clk) begin : proc_sram_write_enable_r
    if(!reset_n) begin
        q_state_input_sram_write_enable_r  <= 1'b0;
        q_gates_sram_write_enable_r        <= 1'b0;
        scratchpad_sram_write_enable_r     <= 1'b0;
        q_state_output_sram_write_enable_r <= 1'b0;
    end else begin
      if (sram_write_enable_sel == 2'b01) begin
        q_state_input_sram_write_enable_r  <= 1'b0;
        q_gates_sram_write_enable_r        <= 1'b0;
        scratchpad_sram_write_enable_r     <= 1'b1;
        q_state_output_sram_write_enable_r <= 1'b0;
      end
      else if (sram_write_enable_sel == 2'b10) begin
        q_state_input_sram_write_enable_r  <= 1'b0;
        q_gates_sram_write_enable_r        <= 1'b0;
        scratchpad_sram_write_enable_r     <= 1'b0;
        q_state_output_sram_write_enable_r <= 1'b1;
      end
      else begin
        q_state_input_sram_write_enable_r  <= 1'b0;
        q_gates_sram_write_enable_r        <= 1'b0;
        scratchpad_sram_write_enable_r     <= 1'b0;
        q_state_output_sram_write_enable_r <= 1'b0;
      end
    end
  end

  assign q_state_input_sram_write_enable  = q_state_input_sram_write_enable_r ;
  assign q_gates_sram_write_enable        = q_gates_sram_write_enable_r       ;
  assign scratchpad_sram_write_enable     = scratchpad_sram_write_enable_r    ;
  assign q_state_output_sram_write_enable = q_state_output_sram_write_enable_r;

  // SCRATCHPAD address controller logic
  always @(posedge clk) begin : proc_scratchpad_write_address_control
    if(!reset_n)
      scratchpad_address_counter <= `SRAM_DATA_WIDTH'b0;
    else begin
      if (scratchpad_address_controller == 2'b01)
	scratchpad_address_counter <= scratchpad_address_counter + 1;
      else if (scratchpad_address_controller == 2'b10)
	scratchpad_address_counter <= scratchpad_address_counter;
      else 
	scratchpad_address_counter <= `SRAM_DATA_WIDTH'b0;
    end
  end

  // SCRATCHPAD SRAM write address logic
  always @(posedge clk) begin : proc_scratchpad_sram_write_address_r
    if(!reset_n) begin
      scratchpad_sram_write_address_r <= 1'b0;
    end else begin  
      scratchpad_sram_write_address_r <= scratchpad_address_counter;  
    end
  end

  assign scratchpad_sram_write_address = scratchpad_sram_write_address_r;

  // SCRATCHPAD SRAM write data logic
  always @(posedge clk) begin : proc_scratchpad_sram_write_data_r
    if(!reset_n) begin
      scratchpad_sram_write_data_r <= `SRAM_DATA_WIDTH'b0;
    end else begin
      scratchpad_sram_write_data_r <= (sram_write_enable_sel == 2'b01) ? {z_inst_adder1, z_inst_adder2} : `SRAM_DATA_WIDTH'b0;
    end
  end

  assign scratchpad_sram_write_data = scratchpad_sram_write_data_r;

  // OUTPUT SRAM write address logic
  always @(posedge clk) begin : proc_q_state_output_sram_write_address_r
    if(!reset_n) 
      q_state_output_sram_write_address_r <= `SRAM_DATA_WIDTH'b0;
    else begin
      if (q_state_output_write_addr_sel == 2'b01)
	q_state_output_sram_write_address_r <= q_state_output_sram_write_address_r + 1;
      else if (q_state_output_write_addr_sel == 2'b10)
	q_state_output_sram_write_address_r <= q_state_output_sram_write_address_r;
      else 
	q_state_output_sram_write_address_r <= `SRAM_DATA_WIDTH'b0;
    end
  end

  assign q_state_output_sram_write_address = q_state_output_sram_write_address_r;

  // OUTPUT SRAM write data logic
  always @(posedge clk) begin : proc_q_state_output_sram_write_data_r
    if(!reset_n) begin
      q_state_output_sram_write_data_r <= `SRAM_DATA_WIDTH'b0;
    end else begin
      q_state_output_sram_write_data_r <= (sram_write_enable_sel == 2'b10) ? {z_inst_adder1, z_inst_adder2} : `SRAM_DATA_WIDTH'b0;
    end
  end

  assign q_state_output_sram_write_data = q_state_output_sram_write_data_r;

  // Multiplication and Accumulation logic 
  always @(posedge clk) begin : proc_mac
    if(!reset_n) begin
      inst_a1      <= `SRAM_DATA_WIDTH'b0;
      inst_b1      <= `SRAM_DATA_WIDTH'b0;
      inst_c1      <= `SRAM_DATA_WIDTH'b0;
      inst_a2      <= `SRAM_DATA_WIDTH'b0;
      inst_b2      <= `SRAM_DATA_WIDTH'b0;
      inst_c2      <= `SRAM_DATA_WIDTH'b0;
      inst_rnd_mac <= `SRAM_DATA_WIDTH'b0;
    end else begin
      if (input_sram_sel) begin
        if (compute_mac == 2'b01) begin
	  inst_a1       <= q_gates_sram_read_data[63:0];
          inst_b1       <= scratchpad_sram_read_data[63:0];
          inst_c1       <= temp_mac1;
          inst_a2       <= q_gates_sram_read_data[127:64];
          inst_b2       <= scratchpad_sram_read_data[63:0];
          inst_c2       <= temp_mac2;
          inst_rnd_mac  <= `SRAM_DATA_WIDTH'b100;
        end
        else if (compute_mac == 2'b10) begin
	  inst_a1       <= q_gates_sram_read_data[127:64];
          inst_b1       <= scratchpad_sram_read_data[127:64];
          inst_c1       <= temp_mac1;
          inst_a2       <= q_gates_sram_read_data[63:0];
          inst_b2       <= scratchpad_sram_read_data[127:64];
          inst_c2       <= temp_mac2;
          inst_rnd_mac  <= `SRAM_DATA_WIDTH'b100;
        end
        else begin
	  inst_a1      <= `SRAM_DATA_WIDTH'b0;
          inst_b1      <= `SRAM_DATA_WIDTH'b0;
          inst_c1      <= `SRAM_DATA_WIDTH'b0;
          inst_a2      <= `SRAM_DATA_WIDTH'b0;
          inst_b2      <= `SRAM_DATA_WIDTH'b0;
          inst_c2      <= `SRAM_DATA_WIDTH'b0;
          inst_rnd_mac <= `SRAM_DATA_WIDTH'b0;
        end
      end
      else begin
        if (compute_mac == 2'b01) begin
	  inst_a1       <= q_gates_sram_read_data[63:0];
          inst_b1       <= q_state_input_sram_read_data[63:0];
          inst_c1       <= temp_mac1;
          inst_a2       <= q_gates_sram_read_data[127:64];
          inst_b2       <= q_state_input_sram_read_data[63:0];
          inst_c2       <= temp_mac2;
          inst_rnd_mac  <= `SRAM_DATA_WIDTH'b100;
        end
        else if (compute_mac == 2'b10) begin
	  inst_a1       <= q_gates_sram_read_data[127:64];
          inst_b1       <= q_state_input_sram_read_data[127:64];
          inst_c1       <= temp_mac1;
          inst_a2       <= q_gates_sram_read_data[63:0];
          inst_b2       <= q_state_input_sram_read_data[127:64];
          inst_c2       <= temp_mac2;
          inst_rnd_mac  <= `SRAM_DATA_WIDTH'b100;
        end
        else begin
	  inst_a1      <= `SRAM_DATA_WIDTH'b0;
          inst_b1      <= `SRAM_DATA_WIDTH'b0;
          inst_c1      <= `SRAM_DATA_WIDTH'b0;
          inst_a2      <= `SRAM_DATA_WIDTH'b0;
          inst_b2      <= `SRAM_DATA_WIDTH'b0;
          inst_c2      <= `SRAM_DATA_WIDTH'b0;
          inst_rnd_mac <= `SRAM_DATA_WIDTH'b0;
        end
      end
    end
  end

  // Temp addend control
  always @(posedge clk) begin : proc_temp_control_addend
    if (!reset_n) begin
      temp_mac1 <= `SRAM_DATA_WIDTH'b0;
      temp_mac2 <= `SRAM_DATA_WIDTH'b0;
    end
    else begin
      if (temp_addend_control == 2'b01) begin
        temp_mac1 <= {~z_inst_mac1[63],z_inst_mac1[62:0]};
        temp_mac2 <= z_inst_mac2;
      end
      else if (temp_addend_control == 2'b10) begin
	temp_mac1 <= temp_mac1;
	temp_mac2 <= temp_mac2;
      end
      else begin
        temp_mac1 <= `SRAM_DATA_WIDTH'b0;
        temp_mac2 <= `SRAM_DATA_WIDTH'b0;
      end
    end
  end

  // Adder logic
  always @(posedge clk) begin : proc_adder
    if(!reset_n) begin
      inst_a3        <= `SRAM_DATA_WIDTH'b0;
      inst_b3        <= `SRAM_DATA_WIDTH'b0;
      inst_a4        <= `SRAM_DATA_WIDTH'b0;
      inst_b4        <= `SRAM_DATA_WIDTH'b0;
      inst_rnd_adder <= `SRAM_DATA_WIDTH'b0;
    end else begin
      if (compute_adder) begin
	inst_a3        <= z_inst_mac1;
	inst_b3	       <= temp_adder1;
	inst_a4	       <= z_inst_mac2;
	inst_b4	       <= temp_adder2;
	inst_rnd_adder <= 3'd0;
      end
      else begin
	inst_a3        <= `SRAM_DATA_WIDTH'b0;
	inst_b3	       <= `SRAM_DATA_WIDTH'b0;
	inst_a4        <= `SRAM_DATA_WIDTH'b0;
        inst_b4        <= `SRAM_DATA_WIDTH'b0;
	inst_rnd_adder <= 3'd0;
      end
    end
  end

  // Temp adder control
  always @(posedge clk) begin : proc_temp_control_adder
    if (!reset_n) begin
      temp_adder1 <= `SRAM_DATA_WIDTH'b0;
      temp_adder2 <= `SRAM_DATA_WIDTH'b0;
    end
    else begin
      if (temp_adder_control == 2'b01) begin
        temp_adder1 <= z_inst_adder1;
	temp_adder2 <= z_inst_adder2;
      end
      else if (temp_adder_control == 2'b10) begin
	temp_adder1 <= temp_adder1;
	temp_adder2 <= temp_adder2;
      end
      else begin
        temp_adder1 <= `SRAM_DATA_WIDTH'b0;
        temp_adder2 <= `SRAM_DATA_WIDTH'b0;
      end
    end
  end

  // Instance 1 of DW_fp_mac
  DW_fp_mac #(inst_sig_width_mac, inst_exp_width_mac, inst_ieee_compliance_mac) U1 (
    .a(inst_a1),
    .b(inst_b1),
    .c(inst_c1),
    .rnd(inst_rnd_mac),
    .z(z_inst_mac1),
    .status(status_inst_mac1) 
  );


  // Instance 2 of DW_fp_mac
  DW_fp_mac #(inst_sig_width_mac, inst_exp_width_mac, inst_ieee_compliance_mac) U2 (
    .a(inst_a2),
    .b(inst_b2),
    .c(inst_c2),
    .rnd(inst_rnd_mac),
    .z(z_inst_mac2),
    .status(status_inst_mac2) 
  );

  // Instance 1 of DW_fp_add
  DW_fp_add #(inst_sig_width_adder, inst_exp_width_adder, inst_ieee_compliance_adder) U3 (
    .a(inst_a3),
    .b(inst_b3),
    .rnd(inst_rnd_adder),
    .z(z_inst_adder1),
    .status(status_inst_adder1) 
  );

  // Instance 2 of DW_fp_add
  DW_fp_add #(inst_sig_width_adder, inst_exp_width_adder, inst_ieee_compliance_adder) U4 (
    .a(inst_a4),
    .b(inst_b4),
    .rnd(inst_rnd_adder),
    .z(z_inst_adder2),
    .status(status_inst_adder2) 
  );
endmodule
