##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
class BillingsController < ApplicationController
  respond_to :html, :js

  before_action :stick_keys, only: [:index, :callback_url]
  def index
    logger.debug "> Billings index."
    @currencies = Billings.currencies
    @bill = Balances.new.show(params)
    @bill.balance

    @billingHistories = Billinghistories.new.list(params)
    @billingHistories.bhistories

  end

  def callback_url
    bill = Billings.new
    res = bill.execute(params)

    redirect_to cockpits_path, :gflash => { :warning => { :value => "PayPal transaction got error. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } } unless res != Megam::Error

    sbalance = Balances.new.show(params)
    api_params = params.merge(sbalance.balance.to_hash)
    api_params["credit"] = sbalance.balance.credit.to_i + res.to_i
    Balances.new.update(api_params)
    Credithistories.new.create(api_params, res)

    redirect_to billings_path
  end

  def create
    res = Billings.new.create(params)
    if res.class == Megam::Error
      respond_to do |format|
        format.html {redirect_to billings_path}
        format.js {render :js => "window.location.href='"+billings_path+"'"}
      end
    else
      respond_to do |format|
        format.html {redirect_to res}
        format.js {render :js => "window.location.href='"+res+"'"}
      end
    end
  end

end
