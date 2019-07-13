module.exports = function(toolkit){
    return {
        init: function(render){
            const self = this;
            const post = this.req.body;
            switch(this.view.post.type){
                case "list":
                    toolkit.seedobjects.world(post.world).getAll(function(err, data){
                        if(err) self.view.error = err;
                        else self.view.all = data;
                        render();
                    });
                    break;
                case "info":
                    toolkit.seedobjects.world(post.world).get(post.mod, post.group, post.id, (err, obj)=>{
                        self.view.out = JSON.stringify({
                            err:err,
                            data:obj
                        });
                        render();
                    });
                    break;
                case "update":
                    toolkit.seedobjects.world(post.world).update(post.mod, post.group, post.object, (err, updated)=>{
                        self.view.out = JSON.stringify({
                            err:err,
                            data:updated
                        });
                        render();
                    });
                    break;
                case "delete":
                    toolkit.seedobjects.world(post.world).delete(post.mod, post.group, post.id, (err, deleted)=>{
                        self.view.out = JSON.stringify({
                            err:err,
                            data:deleted
                        });
                        render();
                    });
                    break;
                case "add":
                    toolkit.seedobjects.world(post.world).add(post.mod, post.group, post.object, (err, added)=>{
                        out = JSON.stringify({
                            err:err,
                            data:added
                        });
                        render();
                    });
                    break;
                default:
                    render(); //prevent a hang
            }
        }
    }
}