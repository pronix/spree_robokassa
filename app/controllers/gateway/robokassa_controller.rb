class Gateway::RobokassaController < Spree::BaseController
  skip_before_filter :verify_authenticity_token, :only => [:result, :success, :fail]
  before_filter :load_order,                     :only => [:result, :success, :fail]

  def show
    @order =  Order.find(params[:order_id])
    @gateway = @order.available_payment_methods.find{|x| x.id == params[:gateway_id].to_i }
    @order.payments.destroy_all
    payment = @order.payments.create!(:amount => 0,  :payment_method_id => @gateway.id)

    if @order.blank? || @gateway.blank?
      flash[:error] = I18n.t("Invalid arguments")
      redirect_to :back
    else
      @signature =  Digest::MD5.hexdigest([ @gateway.options[:mrch_login],
                                            @order.total, @order.id, @gateway.options[:password1]
                                          ].join(':')).upcase
      render :action => :show
    end
  end

  def result
    if @order && @gateway && valid_signature?(@gateway.options[:password2])
      payment = @order.payments.first
      payment.state = "completed"
      payment.amount = params["OutSum"].to_f
      payment.save
      @order.save!
      @order.next! until @order.state == "complete"
      render :text => "OK#{@order.id}"
    else
      render :text => "Invalid Signature"
    end
  end

  def success
    if @order && @gateway && valid_signature?(@gateway.options[:password1]) && @order.complete?
      session[:order_id] = nil
      redirect_to order_path(@order)
    else
      flash[:error] =  t("payment_fail")
      redirect_to root_url
    end
  end

  def fail
    flash.now[:error] = t("payment_fail")
    redirect_to @order.blank? ? root_url : edit_order_checkout_url(@order, :step => "payment")
  end

  private

  def load_order
    @order   = Order.find_by_id(params["InvId"])
    @gateway = @order && @order.payments.first.payment_method
  end

  def valid_signature?(key)
    params["SignatureValue"] ==   Digest::MD5.hexdigest([params["OutSum"], params["InvId"], key ].join(':')).upcase
  end

end
