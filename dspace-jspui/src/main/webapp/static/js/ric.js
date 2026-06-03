$(function () {
    $('[data-toggle="tooltip"]').tooltip();
  })

$(function () {
    $('[data-toggle="tooltip"]').tooltip();
  })

  $(document).ready(function() {
    // 1. Procura todos os botões "Add" na página de submissão (indica que é repeatable)
    $("input[type='submit'][name$='_add'], button[name$='_add']").each(function() {
        var btnAdd = $(this);
        var btnName = btnAdd.attr('name');
        
        // Extrai o nome do metadado. Ex: "submit_dc_identifier_registration_add" vira "dc_identifier_registration"
        var baseName = btnName.replace('submit_', '').replace('_add', '');
        
        // 2. Verifica se é um campo 'onebox' (o input de texto tem exatamente o nome do baseName)
        var inputField = $("input[type='text'][name='" + baseName + "']");
        
        // 3. Verifica se NÃO possui vocabulário controlado / autoridade (não existe botão _lookup)
        var hasLookup = $("input[type='submit'][name='submit_" + baseName + "_lookup']").length > 0;
        
        // Se atende a todos os requisitos, injetamos a interface de cópia em lote
        if (inputField.length > 0 && !hasLookup) {
            
            // Cria o botão que ficará ao lado do input
            var btnBatch = $('<button type="button" class="btn btn-info btn-sm" style="margin-left:10px;">Colar Múltiplos</button>');
            
            // Cria o container oculto com o textarea
            var divBatch = $('<div class="batch-container" style="display:none; margin-top:10px; padding:10px; background:#f9f9f9; border:1px solid #ddd;">' +
                             '<p style="font-size:12px; margin-bottom:5px;">Cole os valores abaixo (um por linha):</p>' +
                             '<textarea rows="5" class="form-control" style="width:100%; margin-bottom:10px;"></textarea>' +
                             '<button type="button" class="btn btn-success btn-sm btn-processar">Adicionar Valores</button> ' +
                             '<button type="button" class="btn btn-default btn-sm btn-cancelar">Cancelar</button>' +
                             '</div>');
            
            // Insere os elementos na tela logo após o botão "Add" padrão do DSpace
            btnAdd.after(btnBatch);
            btnBatch.after(divBatch);
            
            // Ação de abrir a caixa de texto
            btnBatch.click(function(e) {
                e.preventDefault();
                divBatch.slideToggle('fast');
            });
            
            // Ação de cancelar (fecha a caixa)
            divBatch.find('.btn-cancelar').click(function(e) {
                e.preventDefault();
                divBatch.slideUp('fast');
                divBatch.find('textarea').val('');
            });
            
            // Ação de processar os dados colados
            divBatch.find('.btn-processar').click(function(e) {
                e.preventDefault();
                var lines = divBatch.find('textarea').val().split('\n');
                var currentInput = inputField;
                var first = true;
                
                for(var i = 0; i < lines.length; i++) {
                    var val = lines[i].trim();
                    if (val !== "") {
                        if (first) {
                            // Preenche a caixa original vazia do DSpace com o primeiro valor
                            currentInput.val(val);
                            first = false;
                        } else {
                            // Clona o input nativo, preenche e adiciona abaixo na tela
                            var clone = currentInput.clone();
                            clone.val(val);
                            clone.css('margin-top', '5px');
                            currentInput.after(clone);
                            currentInput = clone; // O próximo clone ficará abaixo deste
                        }
                    }
                }
                
                divBatch.slideUp('fast');
                divBatch.find('textarea').val('');
                alert("Campos gerados com sucesso! Não se esqueça de clicar em 'Salvar' ou 'Próximo' para gravar no banco.");
            });
        }
    });
});
