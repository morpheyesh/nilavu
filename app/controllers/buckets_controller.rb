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
## WITHOUT WARRANTIE  S OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
require 'json'

class BucketsController < NilavuController
  respond_to :json, :js

  before_action :stick_ceph_keys, only: [:index, :create, :show, :upload]

  def index
    @bucket = Buckets.new(params).list
    @usage  = BackupUser.new(params).usage(currrent_user.email)
  end

  def create
    bucket = Buckets.new(params)
    bucket.create(params[:bucket_name])
    @msg = { title: "Storage", message: '#{params["bucket_name"]} created successfully.', redirect: '/', disposal_id: 'create_bucket' }
  end

  def show
    logger.debug '> Buckets: show.'
    @objects = BucketObjects.new(params).list_detail
    @bucket_name = params["id"]
  end

  def destroy
    puts "Megam Systems"
  end
end
