require 'spec_helper'
describe ScmProjectsController do
  before(:each) do
    @scm_project= mock_model(ScmProject)
  end
  describe "GET new" do
    it "should render new template" do
      login_user( 'admin?' => true )
      ScmProject.should_receive(:new).and_return(@scm_project)
      get :new
      response.should render_template('scm_projects/new')
    end
    it "should redirect to last url, if user not have create project permission" do
      login_user('admin?' => false )
      get :new
      response.should  be_redirect
    end
  end
  describe "POST create" do
    context "user with admin permission" do
      before(:each) do
        login_user( 'admin?' => true )
      end
      context "with valiad params" do
        before(:each) do
          ScmProject.should_receive(:new).with('these' => 'params').and_return(@scm_project = mock_model(ScmProject, { :save=>true}))
          post :create, :scm_project => { :these=>'params'}
        end
        it "should redirect to show action" do
          response.should redirect_to(scm_project_url(@scm_project))
        end
      end
      context "with invalid params" do
        before(:each) do
          ScmProject.should_receive(:new).with('these'=>'params').and_return(@scm_project = mock_model(ScmProject,{ :save=>false}))
          post :create,:scm_project =>  { :these=>'params'}
        end
        it "should render new template" do
          response.should render_template('scm_projects/new')
        end
      end
    end
    context "user without admin permission" do
      before(:each) do
        login_user('admin?' => false )
        post :create, :scm_project =>  { :these=>'params' }
      end
      it "should redirect to last" do
        response.should be_redirect
      end
      it "should not create scm project" do
        ScmProject.should_not_receive(:new)
      end
    end
  end
end
